# encoding: UTF-8

class MapWKT::Overlay::Marker < MapWKT::Overlay
  def js_output (map_name = nil)
    "new google.maps.Marker({#{" map: #{map_name}," if map_name} position: new google.maps.LatLng(#{self.geometry.latitude_f},#{self.geometry.longitude_f}) })"
  end
end
