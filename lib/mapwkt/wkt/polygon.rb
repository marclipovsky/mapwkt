# encoding: UTF-8

class MapWKT::Geometry::Polygon < MapWKT::Geometry
  # Returns a Point midway between the N/S- & E/W-most Points in the perimeter.
  def center
    self.perimeter.center
  end
  
  # Returns a new MapWKT::Geometry::Polygon with the given outer perimeter and
  # internal lacunae. If the given LineStrings were unclosed, closes them for
  # use in the Polygon, but leaves the original LineStrings unchanged.
  def initialize (perimeter, *lacunae)
    @perimeter = perimeter.dup.close!
    @lacunae = lacunae.map {|lacuna| lacuna.dup.close! }
  end
  
  # Returns an array of LineStrings representing the geographical areas treated
  # as lacunae in this Polygon's enclosed area. Does not return the objects
  # themselves, nor the actual array containing them.
  def lacunae
    @lacunae.map(&:dup)
  end
  
  # Returns a LineString representing the geographical area treated as the
  # outer perimeter of this Polygon's enclosed area. Does not return the actual
  # LineString object used in this Polygon.
  def perimeter
    @perimeter.dup
  end
  
  # Returns a string representation of this Polygon. ⭓ indicates the perimeter
  # LineString, while ⬠ indicates a lacuna LineString.
  def to_s
    "⭓ #{@perimeter.points.join(", ")} ⭓#{@lacunae.map {|lacuna| " | ⬠ #{lacuna.points.join(", ")} ⬠" }.join} "
  end
  
  # Returns this Polygon's WKT representation, with latitudes and longitudes
  # rounded to 7 decimal places.
  def wkt
    "POLYGON((#{[*@perimeter.points, @perimeter.points.first].map {|p| "#{p.longitude_f} #{p.latitude_f}" }.join(", ")})#{@lacunae.map {|lacuna| ", (#{[*lacuna.points, lacuna.points.first].map {|p| "#{p.longitude_f} #{p.latitude_f}" }.join(", ")})" }.join })"
  end
end
