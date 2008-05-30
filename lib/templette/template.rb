require 'yaml'

TEMPLATE_DIR = 'templates'
module Templette
  class Template
    attr_accessor :name
    
    def initialize(name)
      @name = name
    end
  
    def to_html
      raise TemplateError.new("Template rendering failed.  File not found: #{@name}") unless File.exists?(path)
      File.read(path)
    end

    private
      def path
        "#{TEMPLATE_DIR}/#{@name}.html"
      end
  end
end