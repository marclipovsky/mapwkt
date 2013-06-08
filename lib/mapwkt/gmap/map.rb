# encoding: UTF-8

class MapWKT::Map
  def center
    return @center if @center
    return if self.overlays.empty?
    
    n, s, e, w = nil
    
    self.overlays.each do |o|
      n = o.center.y if !n || o.center.y > n
      s = o.center.y if !s || o.center.y < s
      e = o.center.x if !e || o.center.x > e
      w = o.center.x if !w || o.center.x < w
    end
    
    x = (e + w) / 2
    y = (n + s) / 2
    
    @center = MapWKT::Geometry::Point.new(y, x)
  end
  
  def center= (center)
    return unless MapWKT::Geometry::Point === center
    @center = center
  end
  
  def id
    @id
  end
  
  def id= (id)
    return unless id
    raise(ArgumentError, "invalid HTML id: #{id.to_json}") unless id =~ /^[a-zA-Z][\w\d.:-]*$/
    @id = id
  end
  
  def initialize (arg = {})
    @overlays = []
    
    self.options = case arg
      when String then { id: arg }
      when Hash then arg
      else {}
    end
  end
  
  def js_initialize
    "mapwkt_#{self.object_id}_initialize()"
  end
  
  def js_output (arg = {})
    self.options = case arg
      when String then { id: arg }
      when Hash then arg
      else {}
    end
    
    raise(ArgumentError, "HMTL id is required") unless self.id
    
<<-JAVASCRIPT.gsub('new google.maps.LatLng','new p')
var options
var map
function mapwkt_#{self.object_id}_initialize ()
{
  var p = google.maps.LatLng
  var element = document.getElementById('#{self.id}')
  options = { center: new google.maps.LatLng(#{self.center.latitude_f},#{self.center.longitude_f}), mapTypeId: google.maps.MapTypeId.#{self.map_type_id}, zoom: #{self.zoom} }
  map = new google.maps.Map(element, options)
  #{self.overlays.map {|obj| obj.js_output('map') }.join("\n  ")}
}
JAVASCRIPT
  end
  
  def map_type_id
    @map_type_id ||= 'ROADMAP'
  end
  
  def map_type_id= (map_type_id)
    return unless map_type_id
    @map_type_id = ([map_type_id.to_s.upcase] & %w:HYBRID ROADMAP SATELLITE TERRAIN:).first || 'ROADMAP'
  end
  
  def options
    {
      center: self.center,
      id: self.id,
      map_type_id: self.map_type_id,
      zoom: self.zoom
    }
  end
  
  def options= (options)
    options.symbolize_keys!
    self.center = options[:center] || self.center
    self.id = options[:id] || self.id
    self.map_type_id = options[:map_type_id] || options[:mapTypeId] || self.map_type_id
    self.zoom = options[:zoom] || self.zoom || 10
  end
  
  def overlays
    self.refresh!
    @overlays
  end
  
  def refresh!
    return self if @refreshed
    @refreshed = true
    
    self.overlays.select! {|p| MapWKT::Overlay === p }
    self
  end
  
  def zoom
    @zoom ||= 10
  end
  
  def zoom= (zoom)
    return unless zoom
    @zoom = [0,[zoom.to_i, 25].min].max
  end
  
  def << (obj)
    overlays = case obj
      when MapWKT::Geometry then [MapWKT::Overlay.new(obj)]
      when MapWKT::Overlay then [obj]
    else
      raise(TypeError, "method `wkt' is not defined for #{obj.inspect}") unless obj.respond_to?(:wkt)
      
      MapWKT::Geometry.parse_wkt(obj.wkt).map do |g|
        {
          MapWKT::Geometry::Point => MapWKT::Overlay::Marker,
          MapWKT::Geometry::LineString => MapWKT::Overlay::Polyline,
          MapWKT::Geometry::Polygon => MapWKT::Overlay::Polygon
        }[g.class].new(g, obj)
      end
    end
    
    self.overlays.push(*overlays)
    self
  end
end
