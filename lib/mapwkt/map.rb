# encoding: UTF-8

class MapWKT::Map
  def center
    self.center_point
  end
  
  def center= (*args)
    self.center_point = *args
  end
  
  def center_point
    @center_point ||= case (obj = self.overlays.first)
      when MapWKT::Point then obj
      when MapWKT::LineString, MapWKT::MultiPoint then obj.first
      when MapWKT::Polygon then obj.shell.first
    end
  end
  
  def center_point= (*args)
    return if args.none?
    @center_point = MapWKT::Point.new(*args)
  end
  
  def element_id
    @element_id
  end
  
  def element_id= (element_id)
    return unless element_id
    raise(ArgumentError, "invalid HTML id: #{element_id.to_json}") unless element_id =~ /^[a-zA-Z][\w\d.:-]*$/
    @element_id = element_id
  end
  
  def id
    self.element_id
  end
  
  def id= (element_id)
    self.element_id = element_id
  end
  
  def initialize (*args)
    @overlays = []
    
    self.options = case (arg = args.first)
      when Hash then arg
      when String then { element_id: arg }
      else {}
    end
  end
  
  def js_output (*args)
    self.options = case (arg = args.first)
      when Hash then arg
      when String then { element_id: arg }
      else {}
    end
    
    raise(ArgumentError, "element_id is required") unless self.element_id
    raise(ArgumentError, "center_point is required") unless self.center_point
    
<<-JAVASCRIPT.gsub('new google.maps.LatLng','new p')
var mapwkt_#{self.object_id}_initialize = function ()
{
  var p = google.maps.LatLng
  var element = document.getElementById(#{self.element_id.to_json})
  var options = { center: #{self.center.js_fragment}, mapTypeId: google.maps.MapTypeId.#{self.mapTypeId}, zoom: #{self.zoom} }
  var map = new google.maps.Map(element, options)
  #{self.overlays.map {|obj| obj.js_output('map', indent = 2) }.join("\n  ")}
}
JAVASCRIPT
  end
  
  def js_initialize
    "mapwkt_#{self.object_id}_initialize()"
  end
  
  def map_type
    @map_type
  end
  
  def map_type= (map_type)
    return unless map_type
    @map_type = ([map_type.to_s.upcase] & %w:HYBRID ROADMAP SATELLITE TERRAIN:).first || 'ROADMAP'
  end
  
  def map_type_id
    self.map_type
  end
  
  def map_type_id= (map_type)
    self.map_type = map_type
  end
  
  def mapTypeId
    self.map_type
  end
  
  def mapTypeId= (map_type)
    self.map_type = map_type
  end
  
  def options
    {
      center_point: self.center_point,
      element_id: self.element_id,
      map_type: self.map_type,
      zoom_level: self.zoom_level
    }
  end
  
  def options= (map_options)
    map_options.symbolize_keys!
    self.center_point = map_options[:center_point] || map_options[:center] || self.center_point
    self.element_id = map_options[:element_id] || map_options[:id] || self.element_id
    self.map_type = map_options[:map_type] || map_options[:map_type_id] || map_options[:mapTypeId] || map_options[:type] || self.map_type || 'ROADMAP'
    self.zoom_level = map_options[:zoom_level] || map_options[:zoom] || self.zoom_level || 10
  end
  
  def overlays
    @overlays
  end
  
  def type
    self.map_type
  end
  
  def type= (map_type)
    self.map_type = map_type
  end
  
  def zoom
    self.zoom_level
  end
  
  def zoom= (zoom_level)
    self.zoom_level = zoom_level
  end
  
  def zoom_level
    @zoom_level
  end
  
  def zoom_level= (zoom_level)
    return unless zoom_level
    @zoom_level = [0,[zoom_level.to_i, 18].min].max
  end
  
  def << (overlay_obj)
    case overlay_obj
      when MapWKT::LineString, MapWKT::MultiLineString, MapWKT::MultiPoint, MapWKT::MultiPolygon, MapWKT::Point, MapWKT::Polygon
        self.overlays << overlay_obj
      
      when String
        self.overlays << MapWKT.parse(overlay_obj)
      
    else
      MapWKT.parse(overlay_obj.wkt)
    end
    
    self
  end
end
