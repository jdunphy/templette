module Templette
  module DataAccessors
    def attributes 
      @attributes ||= {}
    end
        
    def generate_accessor(k, v)
      attributes[k] = v
      instance_eval "def #{k.to_s}; attributes['#{k}']; end"
    end
  
    def method_missing(symbol)  
      raise PageError.new(@page, "No method '#{symbol}' defined in the yaml")
    end
  end
end