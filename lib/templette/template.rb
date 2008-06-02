require 'erb'
require 'yaml'

TEMPLATE_DIR = 'templates'
module Templette
  class Template
    attr_accessor :name
    
    def initialize(name)
      @name = name
    end
  
    def to_html
      raise TemplateError.new(self, "Template rendering failed.  File not found.") unless File.exists?(path)
      File.read(path)
    end
    
    def to_yaml
      YAML::dump(MethodCollector.new(self).to_hash)
    end

    private
      def path
        "#{TEMPLATE_DIR}/#{@name}.html"
      end
  end
  
  class MethodCollector
    
    def initialize(template = nil)
      @methods = {}
      ERB.new(template.to_html, 0, "%<>").result(binding) if(template)        
    end
    
    def method_missing(symbol)
      @methods[symbol.to_s] = MethodCollector.new
    end
    
    def to_hash
      return nil if @methods.empty?
      hash = {}
      @methods.each_pair do |k, v|
        hash[k] = v.to_hash
      end
      hash
    end
  end
end