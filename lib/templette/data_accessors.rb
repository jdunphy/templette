module Templette
  module DataAccessors
    def attributes 
      @attributes ||= {}
    end
        
    def generate_accessor(k, v)
      raise TempletteError.new(page, "Method already defined: #{k}.  Change your config file and stop using it!") if self.methods.include?(k.to_s)
      if v.kind_of?(Hash)
        v = Page::Section.new(page, v)
      elsif v =~ /file:(.*)/
        v = File.open($1) {|f| f.read}
      end
      attributes[k] = v
      instance_eval "def #{k.to_s}; attributes['#{k}']; end"
    end
  
    def method_missing(symbol)        
        raise PageError.new(@page, "No method '#{symbol}' defined in the yaml")
    end
  end
end