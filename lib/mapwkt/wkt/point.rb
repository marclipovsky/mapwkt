# encoding: UTF-8

class MapWKT::Geometry::Point
  # Returns true if this Point lies in the eastern hemisphere, false otherwise.
  def east?
    self.longitude > 0
  end
  
  # Returns true if this Point lies on the equator, false otherwise.
  def equator?
    self.latitude == 0
  end
  
  # Returns a new MapWKT::Geometry::Point with latitude and longitude normalized
  # to fit within the range [-90,90] for latitude and (-180,180] for longitude.
  def initialize (φ, λ)
    # Check arguments.
    if [φ, λ].all? {|arg| arg.respond_to?(:to_f) }
      φ = φ.to_f
      λ = λ.to_f
    else
      raise ArgumentError, "expected (latitude, longitude), got (#{φ.inspect}, #{λ.inspect})"
    end
    
    # Normalize latitude (-90..90) and longitude (-179..180).
    λ += 180 * (((φ / 90 + 1).floor / 2) % 2)
    @y = 90 - (((90 + φ) % 360) - 180).abs
    @x = self.pole? ? 0 : (λ - 180) % -360 + 180
  end
  
  # Returns this Point's latitude as a float, rounded to 7 decimal places.
  def latitude
    self.y.round(7)
  end
  
  # Returns this Point's latitude as a string, rounded to 7 decimal places.
  def latitude_f
    sprintf("%.7f", self.latitude).gsub(/\.?0*$/,'')
  end
  
  # Returns this Point's latitude in degrees N/S, rounded to 7 decimal places.
  def latitude_°
    φ = self.latitude
    direction = (φ == 0) ? "" : (φ > 0) ? "N" : "S"
    
    sprintf("%.7f°%s", φ.abs, direction).gsub(/\.?0*(?=°)/,'')
  end
  
  # Returns this Point's longitude as a float, rounded to 7 decimal places.
  def longitude
    self.x.round(7)
  end
  
  # Returns this Point's longitude as a string, rounded to 7 decimal places.
  def longitude_f
    sprintf("%.7f", self.longitude).gsub(/\.?0*$/,'')
  end
  
  # Returns this Point's longitude in degrees E/W, rounded to 7 decimal places.
  def longitude_°
    λ = self.longitude
    direction = [0, 180].include?(λ) ? "" : (λ > 0) ? "E" : "W"
    
    sprintf("%.7f°%s", λ.abs, direction).gsub(/\.?0*(?=°)/,'')
  end
  
  # Returns 1 if this Point is the north pole, -1 if it is the south pole, or nil
  # if it is neither.
  def pole?
    return 1 if self.north_pole?
    return -1 if self.south_pole?
  end
  
  # Returns true if this Point is the north pole.
  def north_pole?
    self.latitude == 90
  end
  
  # Returns true if this Point is the south pole.
  def south_pole?
    self.latitude == -90
  end
  
  # Returns a string representation of this Point.
  def to_s
    "#{self.latitude_°} #{self.longitude_°}"
  end
  
  # Returns true if this Point lies in the western hemisphere, false otherwise.
  def west?
    self.longitude < 0
  end
  
  # Returns this Point's WKT representation, rounded to 7 decimal places.
  def wkt
    "POINT(#{self.longitude_f} #{self.latitude_f})"
  end
  
  # Returns this Point's longitude as a float.
  def x
    @x
  end
  
  # Returns this Point's latitude as a float.
  def y
    @y
  end
  
  # Returns true if this Point matches the other Point, within 7 decimal places.
  def == (other)
    [self.latitude, self.longitude] == [other.latitude, other.longitude]
  end
  
  # Returns true if this Point matches the other Point exactly.
  def === (other)
    [self.x, self.y] == [other.x, other.y]
  end
end
