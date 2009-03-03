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
    def initialize(name, default_engine = Templette::config[:default_engine])
      @name = name
      @default_engine = default_engine
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

    def file_type
      parts = path.split('.')
      extensions = []
      found_name = false
      # don't want to just re-join parts[1..parts.length], because a . in a dir name will cause incorrect results
      parts.each do |p|
        if found_name
          extensions << p unless p == type
        else
          found_name = (p =~ /#{@name}$/)
        end
      end
      extensions.join('.')
    end

    private

      def path
        @path ||= (Dir["#{TEMPLATE_DIR}/#{@name}.*"].first || '')
      end
      
      def type
        name_parts = path.split('.')
        # logic: if we saw a filename like x.<type>.<engine>, then the last item is the type of engine to use
        # otherwise, we assume it was of the form x.<type>, and should use the default engine
        if name_parts.length >= 3
          name_parts.last
        else
          @default_engine
        end
      end      
      
      def to_html
        File.read(path)
      end    
      
  end
end