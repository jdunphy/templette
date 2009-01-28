module Templette
  # The Template acts as a layout for pages.  It contains an html layout for the
  # page and contains method calls which are answered by helper methods or the 
  # loaded yaml of a page.
  #
  # Templates now support ERB or Haml for rendering.  
  # * template.html.haml   
  # * template.html.erb   
  # * template.html  -> defaults to ERB   
  # 
  # Additional templating languages can be supported by adding a class in the Templette module which 
  # implements do_render(html, the_binding) in the templates/ folder, named appropriately.

  class Template
    TEMPLATE_DIR = 'templates' unless defined?(TEMPLATE_DIR)
    TEMPLATE_LIB_DIR = 'engines'
    
    TEMPLATES = {
      'erb' => {:file => File.dirname(__FILE__) + "/#{TEMPLATE_LIB_DIR}/erb.rb", 
                :class => :ErbTemplate},
      'haml' => {:file => File.dirname(__FILE__) + "/#{TEMPLATE_LIB_DIR}/haml.rb", 
                  :class => :HamlTemplate}
    }
    
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
    
    def render(the_binding)
      raise TemplateError.new(self, "Template rendering failed.  File not found.") unless File.exists?(path)
      spec = TEMPLATES[type]
      raise TemplateError.new(self, "Rendering engine #{type} is not supported!") if spec.nil?
      require spec[:file]
      template = Templette.const_get(spec[:class]).new
      template.do_render(to_html, the_binding)
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