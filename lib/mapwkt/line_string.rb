# encoding: UTF-8

class MapWKT::LineString < Array
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
  
  def color
    self.stroke_color
  end
  
  def color= (stroke_color)
    self.stroke_color = stroke_color
  end
  
  def inspect
    "MapWKT::LineString [#{self.join ", "}]"
  end
  
  def js_fragment
    "[#{self.map {|p| p.js_fragment }.join ?,}]"
  end
  
  def js_output (map_name = nil)
    "new google.maps.Polyline({#{"map:#{map_name}," if map_name}path:#{self.js_fragment},strokeColor:'#{self.stroke_color}',strokeOpacity:#{self.stroke_opacity},strokeWeight:#{self.stroke_weight}})"
  end
  
  def opacity
    self.stroke_opacity
  end
  
  def opacity= (stroke_opacity)
    self.stroke_opacity = stroke_opacity
  end
  
  def options
    {
      stroke_color: self.stroke_color,
      stroke_opacity: self.stroke_opacity,
      stroke_weight: self.stroke_weight,
    }
  end
  
  def options= (polyline_options)
    polyline_options.symbolize_keys!
    self.stroke_color = polyline_options[:stroke_color] || polyline_options[:color] || polyline_options[:strokeColor] || self.stroke_color
    self.stroke_opacity = polyline_options[:stroke_opacity] || polyline_options[:opacity] || polyline_options[:strokeOpacity] || self.stroke_opacity
    self.stroke_weight = polyline_options[:stroke_weight] || polyline_options[:weight] || polyline_options[:width] || polyline_options[:strokeWeight] || polyline_options[:strokeWidth] || self.stroke_weight
  end
  
  def push (*point_args)
    points = point_args.map {|arg| MapWKT::Point.new(arg) }
    super(*points)
  end
  
  def stroke_color
    @stroke_color ||= '#CC0000'
  end
  
  def stroke_color= (stroke_color)
    return unless (stroke_color = stroke_color.to_s.upcase) =~ /#[0-9A-F]{6}/
    @stroke_color = stroke_color
  end
  
  def stroke_opacity
    @stroke_opacity ||= 0.5
  end
  
  def stroke_opacity= (stroke_opacity)
    return unless stroke_opacity.respond_to?(:to_f)
    @stroke_opacity = [0.0, [stroke_opacity.to_f, 1.0].min].max
  end
  
  def stroke_weight
    @stroke_weight ||= 2.0
  end
  
  def stroke_weight= (stroke_weight)
    return unless stroke_weight.respond_to?(:to_f)
    @stroke_weight = [0.0, stroke_weight.to_f].max
  end
  
  def stroke_width
    self.stroke_weight
  end
  
  def stroke_width= (stroke_weight)
    self.stroke_weight = stroke_weight
  end
  
  def strokeColor
    self.stroke_color
  end
  
  def strokeColor= (stroke_color)
    self.stroke_color = stroke_color
  end
  
  def strokeOpacity
    self.stroke_opacity
  end
  
  def strokeOpacity= (stroke_opacity)
    self.stroke_opacity = stroke_opacity
  end
  
  def strokeWeight
    self.stroke_weight
  end
  
  def strokeWeight= (stroke_weight)
    self.stroke_weight = stroke_weight
  end
  
  def strokeWidth
    self.stroke_weight
  end
  
  def strokeWidth= (stroke_weight)
    self.stroke_weight = stroke_weight
  end
  
  def to_s
    "MapWKT::LineString [#{self.join ", "}]"
  end
  
  def unshift (*point_args)
    points = point_args.map {|arg| MapWKT::Point.new(arg) }
    super(*points)
  end
  
  def weight
    self.stroke_weight
  end
  
  def weight= (stroke_weight)
    self.stroke_weight = stroke_weight
  end
  
  def width
    self.stroke_weight
  end
  
  def width= (stroke_weight)
    self.stroke_weight = stroke_weight
  end
  
  def wkt
    string = "LINESTRING(#{self.map {|p| "%.10f %.10f" % [p.x, p.y] }.join ", "})"
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
