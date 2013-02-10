# encoding: UTF-8

class MapWKT::MultiLineString < Array
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
  
  
end
