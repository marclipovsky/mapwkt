# encoding: UTF-8

class MapWKT::Overlay
  def center
    self.geometry.center
  end
  
  def geometry
    @geometry
  end
  
  def initialize (geometry, source)
    @geometry = geometry
    @source = source
  end
  
  def source
    @source
  end
end
