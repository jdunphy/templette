module Templette
  # The Template acts as a layout for pages.  It contains an html layout for the
  # page and contains method calls which are answered by helper methods or the 
  # loaded yaml of a page.

  class Template
    TEMPLATE_DIR = 'templates' unless defined?(TEMPLATE_DIR)
    attr_accessor :name
    
    # The name parameter refers to the actual filename of the template.  To load
    # templates/foo.html, a template_name of 'foo' should be given.
    def initialize(name)
      @name = name      
    end
  
    def to_html
      raise TemplateError.new(self, "Template rendering failed.  File not found.") unless File.exists?(path)
      File.read(path)
    end
    
    # Generates the yaml necessary to render empty page yaml files.
    def to_yaml
      {'template_name' => @name, 'sections' => MethodCollector.new(self).to_hash}.to_yaml
    end
    
    # Provides the names of helper_modules to be loaded for a template.
    def helpers
      ["default_helper","#{name}_helper"]
    end
    
    def render(the_binding)
      ERB.new(to_html, 0, "%<>").result(the_binding)
    end

    private
      def path
        "#{TEMPLATE_DIR}/#{@name}.html"
      end
  end
end