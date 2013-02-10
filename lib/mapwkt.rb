# encoding: UTF-8

module MapWKT
  require 'bundler/setup'
  require 'active_support/all'
  
  require_relative 'mapwkt/line_string'
  require_relative 'mapwkt/map'
  require_relative 'mapwkt/multi_line_string'
  require_relative 'mapwkt/multi_point'
  require_relative 'mapwkt/multi_polygon'
  require_relative 'mapwkt/point'
  require_relative 'mapwkt/polygon'
  
  def MapWKT.parse (string, expected_class = nil)
    result = case string.to_s.strip.upcase
      when /^LINESTRING\s*\(\s*([\d\s,.-]*?)\s*\)$/
        # LINESTRING(1 2, 3 4)
        lat_long_pairs = $~[1].split(?,).map do |s|
          s.strip.split(/\s+/).reverse.map(&:to_f)
        end
        
        LineString[*lat_long_pairs]
      
      when /^MULTILINESTRING\s*\(\s*(\([\d\s,.-]*?\)(?:\s*,\s*\([\d\s,.-]*?\))*)\s*\)$/
        return $~[1]
      
      when /^MULTIPOINT\s*\(\s*([\d\s,.-]*?)\s*\)$/
        # MULTIPOINT(1 2, 3 4)
        lat_long_pairs = $~[1].split(?,).map do |s|
          s.strip.split(/\s+/).reverse.map(&:to_f)
        end
        
        MultiPoint[*lat_long_pairs]
      
      when /^MULTIPOINT\s*\(\s*(\([\d\s,.-]*?\)(?:\s*,\s*\([\d\s,.-]*?\))*)\s*\)$/
        # MULTIPOINT((1 2), (3 4))
        lat_long_pairs = $~[1].scan(/\(\s*([^()]*?)\s*\)/).flatten.map do |s|
          s.strip.split(/\s+/).reverse.map(&:to_f)
        end
        
        MultiPoint[*lat_long_pairs]
      
      when /^MULTIPOLYGON\s*\(\s*(\(\s*\([\d\s,.-]*?\)(?:\s*,\s*\([\d\s,.-]*?\))*\s*\)(?:\s*,\s*\(\s*\([\d\s,.-]*?\)(?:\s*,\s*\([\d\s,.-]*?\))*\s*\))*)\s*\)$/
        return $~[1]
      
      when /^POINT\s*\(([\d\s.-]*?)\)$/
        # POINT(1 2)
        lat, long = $~[1].strip.split(/\s+/).reverse.map(&:to_f)
        Point.new(latitude: lat, longitude: long)
      
      when /^POLYGON\s*\(\s*(\([\d\s,.-]*?\)(?:\s*,\s*\([\d\s,.-]*?\))*)\s*\)$/
        shell_string, *hole_strings = $~[1].scan(/\(\s*([^()]*?)\s*\)/).flatten
        
        shell_lat_long_pairs = shell_string.split(?,).map do |s|
          s.strip.split(/\s+/).reverse.map(&:to_f)
        end
        
        shell_linestring =  LineString[*shell_lat_long_pairs]
        
        hole_linestrings = hole_strings.map do |hole_string|
          hole_lat_long_pairs = hole_string.split(?,).map do |s|
            s.strip.split(/\s+/).reverse.map(&:to_f)
          end
          
          LineString[*hole_lat_long_pairs]
        end
        
        Polygon.new(shell: shell_linestring, holes: hole_linestrings)
      
    else
      raise ArgumentError, "not a valid WKT string: #{string.inspect}"
    end
    
    return result if (expected_class == result.class) || !(Class === expected_class)
    
    raise TypeError, "expected #{expected_class}, result was #{result.class}"
  end
end
