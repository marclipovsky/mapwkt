# encoding: UTF-8

Geometry = Class.new
Map = Class.new
Overlay = Class.new

LineString = Class.new(Geometry)
Point = Class.new(Geometry)
Polygon = Class.new(Geometry)

Marker = Class.new(Overlay)
PolygonOverlay = Class.new(Overlay)
Polyline = Class.new(Overlay)

# Register the class names in the top-level namespace.
[
  Geometry, LineString, Map, Marker, Overlay,
  Point, Polygon, PolygonOverlay, Polyline
].map(&:name)

# Create the namespaced constants pointing to the classes.
module MapWKT
  Geometry = ::Geometry
  Map = ::Map
  Overlay = ::Overlay
  
  class Geometry
    LineString = ::LineString
    Point = ::Point
    Polygon = ::Polygon
  end
  
  class Overlay
    Marker = ::Marker
    Polygon = ::PolygonOverlay
    Polyline = ::Polyline
  end
  
  require_relative 'mapwkt'
end

def Point (*args) Point.new(*args) end
def LineString (*args) LineString.new(*args) end
def Polygon (*args) Polygon.new(*args) end
