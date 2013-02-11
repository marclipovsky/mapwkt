# encoding: UTF-8

class MapWKT::Geometry::LineString
  # Returns this LineString after closing its endpoints.
  def close!
    self.refresh! unless @refreshed
    @closed = true
    self
  end
  
  # Returns true if this LineString is closed, false otherwise.
  def closed?
    self.refresh!
    @closed ||= false
  end
  
  # Returns a new LineString with the same geographic Points as this LineString.
  def dup
    points = self.points.map(&:dup)
    LineString(*points).tap {|ls| ls.close! if self.closed? }
  end
  
  # Returns a new LineString containing the given Points.
  def initialize (*points)
    @points = points
    self.refresh!
  end
  
  # Returns false if this LineString is closed, true otherwise.
  def open?
    !self.closed?
  end
  
  # Returns this LineString after opening its endpoints.
  def open!
    self.refresh!
    @closed = false
    self
  end
  
  # Returns the array of Points in this LineString.
  def points
    self.refresh!
    @points
  end
  
  # Removes any non-Point objects from this LineString's #points array. If the
  # first Point has been added to the end of the #points array, closes the
  # LineString and removes the Point. Returns this LineString.
  def refresh!
    return self if @refreshed
    @refreshed = true
    
    self.points.select! {|p| MapWKT::Geometry::Point === p }
    
    while (self.points.many?) && (self.points.last == self.points.first)
      self.points.pop
      @closed = true
    end
    
    self
  end
  
  # Returns a string representation of this LineString. ⤿ indicates an open
  # LineString, while ⟲ indicates a closed LineString.
  def to_s
    points = self.points.join(", ")
    marker = self.closed? ? ?⟲ : ?⤿
    
    "#{marker} #{points} #{marker} "
  end
  
  # Returns this LineString's WKT representation, with latitudes and longitudes
  # rounded to 7 decimal places.
  def wkt
    points = self.open? ? self.points : [*self.points, self.points.first]
    "LINESTRING(#{points.map {|p| "#{p.longitude_f} #{p.latitude_f}" }.join(", ")})"
  end
end
