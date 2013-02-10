# encoding: UTF-8

class MapWKT::MultiPoint < Array
  (self.superclass[].methods - Object.methods - [:map, :map!, :collect, :collect!, :to_a]).each do |method_name|
    class_eval <<-EVAL
      def #{method_name} (*)
        result = super
        
        if #{self.superclass} === result
          result = self.class[*result]
        end
        
        result
      
      rescue SystemStackError
        raise SystemStackError, "encountered a problem while executing `#{method_name}': Array may have been expected in place of \#{self.class}"
      end
    EVAL
  end
  
  def self.[] (*point_args)
    points = point_args.map {|arg| MapWKT::Point.new(arg) }
    super(*points)
  end
  
  def inspect
    "MapWKT::MultiPoint [#{self.join ", "}]"
  end
  
  def js_output (map_name = nil)
    self.map {|p| p.js_output(map_name) }.join(?;)
  end
  
  def push (*point_args)
    points = point_args.map {|arg| MapWKT::Point.new(arg) }
    super(*points)
  end
  
  def to_s
    "MapWKT::MultiPoint [#{self.join ", "}]"
  end
  
  def unshift (*point_args)
    points = point_args.map {|arg| MapWKT::Point.new(arg) }
    super(*points)
  end
  
  def wkt
    string = "MULTIPOINT(#{self.map {|p| "%.10f %.10f" % [p.x, p.y] }.join ", "})"
    string.gsub(/(?<=[\d])\.?0+(?=[^\d.])/,'')
  end
  
  def []= (index, arg)
    super(index, MapWKT::Point.new(arg))
    self.compact!
  end
  
  def << (*point_args)
    points = point_args.map {|arg| MapWKT::Point.new(arg) }
    super(*points)
  end
end
