require 'erb'
require 'yaml'

module Templette
  class Template
    TEMPLATE_DIR = 'templates' unless defined?(TEMPLATE_DIR)
    attr_accessor :name
    
    def initialize(name)
      @name = name      
    end
  
    def to_html
      raise TemplateError.new(self, "Template rendering failed.  File not found.") unless File.exists?(path)
      File.read(path)
    end
    
    def to_yaml
      {'template_name' => @name, 'sections' => MethodCollector.new(self).to_hash}.to_yaml
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