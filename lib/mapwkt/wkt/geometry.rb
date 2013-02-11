# encoding: UTF-8

class MapWKT::Geometry
  def self.parse_wkt (wkt_string)
    # Remove extraneous whitespace.
    s = wkt_string.to_s.upcase.strip.gsub(/\s*([),(])\s*/,'\1').gsub(/\s+/,' ')
    
    case s
      when /^POINT\(([\d\s.-]*?)\)$/
        x, y = self.parse_x_y $1
        [MapWKT::Geometry::Point.new(y,x)]
      
      when /^LINESTRING\(([\d\s,.-]*?)\)$/
        points = self.parse_points $1
        [MapWKT::Geometry::LineString.new(*points)]
      
      when /^POLYGON\((\([\d\s,.-]*?\)(?:,\([\d\s,.-]*?\))*)\)$/
        perimeter, lacunae = self.parse_linestrings $1
        [MapWKT::Geometry::Polygon.new(perimeter, *lacunae)]
      
      when /^MULTIPOINT\(([\d\s,.-]*?)\)$/
        self.parse_points $1
      
      when /^MULTIPOINT\((\([\d\s,.-]*?\)(?:,\([\d\s,.-]*?\))*)\)$/
        points_string = $1.gsub(/[()]/,'')
        self.parse_points(points_string)
      
      when /^MULTILINESTRING\((\([\d\s,.-]*?\)(?:,\([\d\s,.-]*?\))*)\)$/
        self.parse_linestrings $1
      
      when /^MULTIPOLYGON\((\(\([\d\s,.-]*?\)(?:,\([\d\s,.-]*?\))*\)(?:,\(\([\d\s,.-]*?\)(?:,\([\d\s,.-]*?\))*\))*)\)$/
        self.parse_polygons $1
      
      when /^GEOMETRYCOLLECTION\((.*?)\)$/
        wkt_strings = $1.scan(/([A-Z]+\(.*?\))(?=,[A-Z]|$)/).flatten
        wkt_strings.map {|wkt_string| self.parse_wkt(wkt_string) }.flatten
      
    else
      raise SyntaxError
    end
    
  rescue SyntaxError
    raise SyntaxError, "not a valid WKT string: #{wkt_string.inspect}"
  end
  
  def self.parse_polygons (polygons_string)
    # Create Polygons from each "((x y, …), (x y, …))" in the polygons string.
    polygons_string.scan(/\((\(.*?\))\)/).flatten.map do |linestrings_string|
      perimeter, lacunae = self.parse_linestrings(linestrings_string)
      MapWKT::Geometry::Polygon.new(perimeter, *lacunae)
    end
  end
  
  def self.parse_linestrings (linestrings_string)
    # Create LineStrings from each "(x y, …)" in the linestrings string.
    linestrings_string.scan(/\((.*?)\)/).flatten.map do |points_string|
      points = self.parse_points(points_string)
      MapWKT::Geometry::LineString.new(*points)
    end
  end
  
  def self.parse_points (points_string)
    # Create Points from each "x y" in the points string.
    points_string.split(?,).map do |x_y_string|
      x, y = self.parse_x_y(x_y_string)
      MapWKT::Geometry::Point.new(y,x)
    end
  end
  
  def self.parse_x_y (x_y_string)
    # Check the string.
    raise SyntaxError unless x_y_string =~ /^(-?\d+(?:\.\d+)?)\s(-?\d+(?:\.\d+)?)$/
    
    # Return the x and y values.
    [$1, $2].map(&:to_f)
  end
end
