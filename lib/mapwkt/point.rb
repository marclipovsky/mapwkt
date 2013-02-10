# encoding: UTF-8

class MapWKT::Point
  def initialize (*args)
    arg = args.first || {}
    
    case arg
      when Hash
        arg.symbolize_keys!
        lat = (arg[:latitude] || arg[:lat] || arg[:y]).to_f
        lon = (arg[:longitude] || arg[:long] || arg[:lon] || arg[:x]).to_f
      
      when Point
        lat, lon = *arg
      
      when String
        lat, lon = *MapWKT.parse(arg, MapWKT::Point)
      
    else
      args = arg if (Array === arg)
      
      if (args.length == 2) && (args.all? {|arg| arg.respond_to? :to_f })
        lat, lon = args.map(&:to_f)
      else
        raise ArgumentError, "expected (latitude, longitude), got (#{args.inspect.gsub /(^\[)|(\]$)/, ''})"
      end
    end
    
    # Normalize latitude (-90..90) and longitude (-179..180).
    @latitude = 90 - (((90 + lat) % 360) - 180).abs
    @longitude = (lon - 180) % -360 + 180
  end
  
  def js_fragment
    string = "new google.maps.LatLng(%.10f,%.10f)" % [*self]
    string.gsub(/(?<=[\d])\.?0+(?=[^\d.])/,'')
  end
  
  def js_output (map_name = nil, indent = 0)
    "new google.maps.Marker({#{" map: #{map_name}," if map_name} position: (#{self.js_fragment}) })"
  end
  
  def lat
    self.latitude
  end
  
  def latitude
    @latitude
  end
  
  def lon
    self.longitude
  end
  
  def long
    self.longitude
  end
  
  def longitude
    @longitude
  end
  
  def to_a
    [self.latitude, self.longitude]
  end
  
  def to_s
    string = "MapWKT::Point [%.10f,%.10f]" % [*self]
    string.gsub(/(?<=[\d])\.?0+(?=[^\d.])/,'')
  end
  
  def wkt
    string = ("POINT(%.10f %.10f)" % [*self].reverse)
    string.gsub(/(?<=[\d])\.?0+(?=[^\d.])/,'')
  end
  
  def x
    self.longitude
  end
  
  def y
    self.latitude
  end
end
