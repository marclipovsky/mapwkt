# encoding: UTF-8

class MapWKT::Overlay
  def center
    @geometry.center
  end
  
  def options
    @options
  end
  
  def options= (options)
    @options
  end
  
  def geometry
    @geometry
  end
  
  def initialize (geometry, source, options = {})
    @geometry = geometry
    @source = source
    @options = options
  end
  
  def source
    @source
  end
end
