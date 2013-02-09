# encoding: UTF-8

module MapWKT
  require_relative 'mapwkt'
  
  ::LineString = LineString unless defined?(::LineString)
  ::MultiLineString = MultiLineString unless defined?(::MultiLineString)
  ::Map = Map unless defined?(::Map)
  ::MultiPoint = MultiPoint unless defined?(::MultiPoint)
  ::MultiPolygon = MultiPolygon unless defined?(::MultiPolygon)
  ::Point = Point unless defined?(::Point)
  ::Polygon = Polygon unless defined?(::Polygon)
end
