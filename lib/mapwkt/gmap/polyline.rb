# encoding: UTF-8

class MapWKT::Overlay::Polyline < MapWKT::Overlay
  def js_output (map_name = nil)
    points = self.geometry.open? ? self.geometry.points : [*self.geometry.points, self.geometry.points.first]
    path = "[#{points.map {|p| "new google.maps.LatLng(#{p.latitude_f},#{p.longitude_f})" }.join(?,)}]"
    
    "new google.maps.Polyline({#{" map: #{map_name}," if map_name} path: #{path} })"
  end
end
