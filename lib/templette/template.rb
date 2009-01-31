module Templette
  # The Template acts as a layout for pages.  It contains an html layout for the
  # page and contains method calls which are answered by helper methods or the 
  # loaded yaml of a page.
  #
  # Templates now support ERB or Haml for rendering.  
  # * template.html.haml   
  # * template.html.erb   
  # * template.html  -> defaults to ERB 

  class Template
    TEMPLATE_DIR = 'templates' unless defined?(TEMPLATE_DIR)
    
    attr_accessor :name
    
    # The name parameter refers to the actual filename of the template.  To load
    # templates/foo.html, a template_name of 'foo' should be given.
    def initialize(name)
      @name = name      
    end
    
    # Generates the yaml necessary to render empty page yaml files.
    def to_yaml
      {'template_name' => @name, 'sections' => MethodCollector.new(self).to_hash}.to_yaml
    end
    
    # Provides the names of helper_modules to be loaded for a template.
    def helpers
      ["default_helper","#{name}_helper"]
    end
    
    # Generates the final HTML.
    def render(the_binding)
      raise TemplateError.new(self, "Template rendering failed.  File not found.") unless File.exists?(path)
      Engineer.engine_for(type).render(to_html, the_binding)
    rescue RenderError => e
      raise TemplateError.new(self, e.message)
    end

    private

      def path
        Dir["#{TEMPLATE_DIR}/#{@name}.html*"].first || ''
      end
      
      def type
        path.match(/html\.?(\w+)?/)[1] || 'erb'
      end      
      
      def to_html
        File.read(path)
      end    
      
  end
end