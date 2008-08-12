module Templette
  module DataAccessors
    def attributes 
      @attributes ||= {}
    end
    
    def generate_accessors(accessors = {})
      accessors.each_pair { |k,v| generate_accessor(k, v) }
    end
        
    def include_helpers(helpers)
      helpers.each { |helper| add_helper(helper) }
    end
    
    def method_missing(symbol)
      raise PageError.new(page, "No method '#{symbol}' defined in the yaml")
    end

    private
    
      def generate_accessor(k, v)
        raise TempletteError.new(page, "Method already defined: #{k}.  Change your config file and stop using it!") if self.methods.include?(k.to_s)
        if v.kind_of?(Hash)
          v = Page::Section.new(page, v)
        elsif v =~ /file:(.*)/
          raise PageError.new(page, "File requested by :#{k} no found!") unless File.exists?($1)
          v = File.open($1) {|f| f.read}
        end
        attributes[k.to_s] = v
        instance_eval "def #{k.to_s}; attributes['#{k.to_s}']; end"
      end

      def add_helper(helper)
        if File.exists?("helpers/#{helper}.rb")
          require "helpers/#{helper}" 
          extend Object.module_eval("::#{helper.split('_').map {|str| str.capitalize}.join}", __FILE__, __LINE__)
        end
      end
  end
end