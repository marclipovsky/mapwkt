# encoding: UTF-8

class MapWKT::Polygon
  def color
    self.fill_color
  end
  
  def color= (fill_color)
    self.fill_color = fill_color
    self.stroke_color = fill_color
  end
  
  def fill_color
    @fill_color ||= self.shell.stroke_color
  end
  
  def fill_color= (fill_color)
    return unless (fill_color = fill_color.to_s.upcase) =~ /#[0-9A-F]{6}/
    @fill_color = fill_color
  end
  
  def fill_opacity
    @fill_opacity ||= self.shell.stroke_opacity
  end
  
  def fill_opacity= (fill_opacity)
    return unless fill_opacity.respond_to?(:to_f)
    @fill_opacity = [0.0, [fill_opacity.to_f, 1.0].min].max
  end
  
  def fillColor
    self.fill_color
  end
  
  def fillColor= (fill_color)
    self.fill_color = fill_color
  end
  
  def fillOpacity
    self.fill_opacity
  end
  
  def fillOpacity= (fill_opacity)
    self.fill_opacity = fill_opacity
  end
  
  def holes
    @holes
  end
  
  def holes= (args)
    return unless args.all? {|arg| MapWKT::LineString === arg }
    @holes = args
  end
  
  def initialize (*args)
    arg = args.first || {}
    
    case arg
      when Hash
        arg.symbolize_keys!
        self.shell = arg[:shell]
        self.holes = arg[:holes]
      
      when LineString
        self.shell = arg
        self.holes = args[1..-1]
      
      when Array
        self.shell = MapWKT::LineString[*args.map {|arg| MapWKT::Point.new(arg) }]
        self.holes = []
      
    else
      self.shell = MapWKT::LineString[]
      self.holes = []
    end
  end
  
  def js_fragment
    "[#{([self.shell] + self.holes).map {|ls| ls.js_fragment }.join ?,}]"
  end
  
  def js_output (map_name = nil, indent = 0)
    i = ' ' * indent
    
<<-JAVASCRIPT.strip
new google.maps.Polygon(
#{i}{#{"\n#{i}  map: #{map_name}," if map_name}
#{i}  strokeColor: '#{self.stroke_color}',
#{i}  strokeOpacity: #{self.stroke_opacity},
#{i}  strokeWeight: #{self.stroke_weight},
#{i}  fillColor: '#{self.fill_color}',
#{i}  fillOpacity: #{self.fill_opacity},
#{i}  paths: #{self.js_fragment}
#{i}})
JAVASCRIPT
  end
  
  def opacity
    self.fill_opacity
  end
  
  def opacity= (fill_opacity)
    self.fill_opacity = fill_opacity
    self.stroke_opacity = fill_opacity
  end
  
  def options
    {
      stroke_color: self.stroke_color,
      stroke_opacity: self.stroke_opacity,
      stroke_weight: self.stroke_weight,
      fill_color: self.fill_color,
      fill_opacity: self.fill_opacity
    }
  end
  
  def options= (polygon_options)
    polygon_options.symbolize_keys!
    self.stroke_color = polygon_options[:stroke_color] || polygon_options[:color] || polygon_options[:strokeColor] || self.stroke_color
    self.stroke_opacity = polygon_options[:stroke_opacity] || polygon_options[:opacity] || polygon_options[:strokeOpacity] || self.stroke_opacity
    self.stroke_weight = polygon_options[:stroke_weight] || polygon_options[:weight] || polygon_options[:width] || polygon_options[:strokeWeight] || polygon_options[:strokeWidth] || self.stroke_weight
    self.fill_color = polygon_options[:fill_color] || polygon_options[:color] || polygon_options[:fillColor] || self.fill_color
    self.fill_opacity = polygon_options[:fill_opacity] || polygon_options[:opacity] || polygon_options[:fillOpacity] || self.fill_opacity
  end
  
  def shell
    @shell
  end
  
  def shell= (arg)
    @shell = arg if MapWKT::LineString === arg
  end
  
  def stroke_color
    @stroke_color ||= self.shell.stroke_color
  end
  
  def stroke_color= (stroke_color)
    return unless (stroke_color = stroke_color.to_s.upcase) =~ /#[0-9A-F]{6}/
    @stroke_color = stroke_color
  end
  
  def stroke_opacity
    @stroke_opacity ||= self.shell.stroke_opacity
  end
  
  def stroke_opacity= (stroke_opacity)
    return unless stroke_opacity.respond_to?(:to_f)
    @stroke_opacity = [0.0, [stroke_opacity.to_f, 1.0].min].max
  end
  
  def stroke_weight
    @stroke_weight ||= self.shell.stroke_weight
  end
  
  def stroke_weight= (stroke_weight)
    return unless stroke_weight.respond_to?(:to_f)
    @stroke_weight = [0.0, stroke_weight.to_f].max
  end
  
  def stroke_width
    self.stroke_weight
  end
  
  def stroke_width= (stroke_weight)
    self.stroke_weight = stroke_weight
  end
  
  def strokeColor
    self.stroke_color
  end
  
  def strokeColor= (stroke_color)
    self.stroke_color = stroke_color
  end
  
  def strokeOpacity
    self.stroke_opacity
  end
  
  def strokeOpacity= (stroke_opacity)
    self.stroke_opacity = stroke_opacity
  end
  
  def strokeWeight
    self.stroke_weight
  end
  
  def strokeWeight= (stroke_weight)
    self.stroke_weight = stroke_weight
  end
  
  def strokeWidth
    self.stroke_weight
  end
  
  def strokeWidth= (stroke_weight)
    self.stroke_weight = stroke_weight
  end
  
  def to_s
    "MapWKT::Polygon [#{self.shell}#{", " + self.holes.map(&:to_s).join(", ") if self.holes.any?}]"
  end
  
  def weight
    self.stroke_weight
  end
  
  def weight= (stroke_weight)
    self.stroke_weight = stroke_weight
  end
  
  def width
    self.stroke_weight
  end
  
  def width= (stroke_weight)
    self.stroke_weight = stroke_weight
  end
  
  def wkt
    string = "POLYGON((#{self.shell.map {|p| "%.10f %.10f" % [p.x, p.y] }.join ", "})#{", " + self.holes.map {|hole| "(#{hole.map {|p| "%.10f %.10f" % [p.x, p.y] }.join ", "})" }.join(", ") if self.holes.any?})"
    string.gsub(/(?<=[\d])\.?0+(?=[^\d.])/,'')
  end
end
