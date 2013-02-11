# encoding: UTF-8

class MapWKT::Overlay::Polygon < MapWKT::Overlay
  def js_output (map_name = nil)
    paths = [self.geometry.perimeter, *self.geometry.lacunae].map do |g|
      points = [*g.points, g.points.first]
      "[#{points.map {|p| "new google.maps.LatLng(#{p.latitude_f},#{p.longitude_f})" }.join(?,)}]"
    end.join(?,)
    
    "new google.maps.Polygon({#{" map: #{map_name}," if map_name} paths: [#{paths}] })"
  end
end
