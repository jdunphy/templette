module Templette

  # The Page is the core object of a Templette project.  Pages won't get generate
  # unless there are available .yml files to build out the necessary info.
  #
  # A general Page yaml structure example:
  #
  #     template_name: main
  #     sections:
  #       title: Page Title
  #       nav:
  #         active-class: foo
  #         title: Foo!
  #
  # The <tt>template_name</tt> will be used to load a template.
  #
  # Everything in <tt>sections</tt> will be made available as methods in the template when
  # it's evaluated by ERB.  Yaml hash items nested within others will be loaded into nested
  # objects.  To call the nav title, the template should call <tt>nav.title</tt>.
  
  class Page

    include Templette::DataAccessors
    attr_reader :name, :template
    
    class <<self
      def pages_dir
        @@pages_dir ||= 'pages'
      end
      
      def pages_dir=(path)
        @@pages_dir = path
      end
  
      # Grabs all of the yaml files found in /pages, and loads them as
      # Page objects.
      def find_all
        Dir["#{pages_dir}/**/*.yml"].map {|f| new f }
      end
    end
  
    def initialize(page_config)
      raise PageError.new(self, "missing page #{page_config}") unless File.exists?(page_config)

      data = YAML::load_file(page_config)
      @name = page_config.dup
      @name.slice!(self.class.pages_dir + '/')
      @name.chomp!('.yml')
      raise PageError.new(self, "missing required section \"template_name\" for page config #{page_config}") unless data['template_name']
      @template = Template.new(data['template_name'])

      raise PageError.new(self, "missing sections in yml for page config #{page_config}") unless data['sections']
      generate_accessors(data['sections'])
      include_helpers(template.helpers)
    end
  
    def generate(out_dir)
      generate_subdirectory(out_dir)
      File.open(output_file_name(out_dir), 'w') do |f| 
        f << @template.render(binding)
      end
    end

    # A requriement of the Templette::DataAccessors interface.  Returns self.
    def page; self end
    
    private

      def output_file_name(out_dir)
        "#{out_dir}/#{@name}.html"
      end
    
      def generate_subdirectory(out_dir)
        FileUtils.mkdir_p(File.expand_path("#{out_dir}/" + name.chomp(File.basename(name)))) if name.index('/')
      end
      
      class Section # :nodoc:
        include Templette::DataAccessors
        attr_reader :page
      
        def initialize(page, hash={})
          @page = page
          generate_accessors(hash)
        end
      
      end 
  end
end
