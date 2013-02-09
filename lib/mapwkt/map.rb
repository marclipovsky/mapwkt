# encoding: UTF-8

class MapWKT::Map
  def center
    self.center_point
  end
  
  def center= (*args)
    self.center_point = *args
  end
  
  def center_point
    @center_point
  end
  
  def center_point= (*args)
    return if args.none?
    @center_point = Point.new(*args)
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
  
  def initialize (map_options = {})
    self.options = map_options
  end
  
  def js_function (map_options = {})
    self.options = map_options
    
<<-JAVASCRIPT
var mapwkt_#{self.object_id}_initialize = function ()
{
  var p = google.maps.LatLng
  var element = document.getElementById(#{self.element_id.to_json})
  var options = { center: #{self.center.to_json}, mapTypeId: google.maps.MapTypeId.#{self.mapTypeId}, zoom: #{self.zoom} }
  var map = new google.maps.Map(element, options)
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
end
