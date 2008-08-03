require 'yaml'
require 'erb'

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
    PAGES_DIR = 'pages' unless defined?(PAGES_DIR)

    include Templette::DataAccessors
    attr_accessor :name, :template
  
    # Grabs all of the yaml files found in /pages, and loads them as
    # Page objects.
    #
    # TODO: This needs to be recursive!  We should support nested page directories.
    def self.find_all
      Dir["#{PAGES_DIR}/*.yml"].map {|f| Page.new(f) }
    end
  
    def initialize(page_config)
      raise PageError.new(self, "missing page #{page_config}") unless File.exists?(page_config)

      data = YAML::load_file(page_config)
      @name = File.basename(page_config, '.yml')
      raise PageError.new(self, "missing required section \"template_name\" for page config #{page_config}") unless data['template_name']
      @template = Template.new(data['template_name'])

      raise PageError.new(self, "missing sections in yml for page config #{page_config}") unless data['sections']
      generate_accessors(data['sections'])
      include_helpers(template.helpers)
    end
  
    def generate(out_dir)
      File.open(output_file_name(out_dir), 'w') do |f| 
        f << ERB.new(@template.to_html, 0, "%<>").result(binding)
      end
    end

    # A requriement of the Templette::DataAccessors interface.  Returns self.
    def page; self end

    def output_file_name(out_dir)
      "#{out_dir}/#{@name}.html"
    end
    private :output_file_name
      
    class Section
      include Templette::DataAccessors
      attr_accessor :page
      
      def initialize(page, hash={})
        @page = page
        generate_accessors(hash)
      end
      
    end 
  end   
    
end

