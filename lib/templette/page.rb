require 'yaml'
require 'erb'

PAGES_DIR = 'pages'
module Templette

  class Page
    include Templette::DataAccessors
    attr_accessor :name, :template
  
    def self.find
      Dir["#{PAGES_DIR}/*.yml"].map {|f| Page.new(f) }
    end
  
    def initialize(page_config)
      raise PageError.new(self, "missing page #{page_config}") unless File.exists?(page_config)
      # TODO(sholder) is this legit?  Will YAML close the file when its done?
      data = YAML::load_file(page_config)
      @name = File.basename(page_config, '.yml')
      raise PageError.new(self, "missing required section \"template_name\" for page config #{page_config}") unless data['template_name']
      @template = Template.new(data['template_name'])

      raise PageError.new(self, "missing sections in yml for page config #{page_config}") unless data['sections']
      data['sections'].each_pair do |k,v|
        generate_accessor(k, v)
      end
      
      @helper_module_name = "#{@template.name.capitalize}Helper"
    end
  
    def output_file_name(out_dir)
      "#{out_dir}/#{@name}.html"
    end
  
    def generate(out_dir)
      File.open(output_file_name(out_dir), 'w') do |f| 
        f << ERB.new(@template.to_html, 0, "%<>").result(binding)
      end
    end
    
    def page 
      self
    end
    
    def method_missing(symbol, *args)
      #does Section also need to do something w/ method_missing?
      begin
        helper_module = Kernel.const_get("#{@helper_module_name}")
        if helper_module.respond_to?(symbol)
          return (args.length > 0 ? helper_module.send(symbol, args) : helper_module.send(symbol))
        end
      rescue NameError
        # try ApplicationHelper by default
        if ApplicationHelper.respond_to?(symbol)
          return (args.length > 0 ? ApplicationHelper.send(symbol, args) : ApplicationHelper.send(symbol))
        end
      end
      raise PageError.new(self, "No method '#{symbol}' defined in the yaml")
    end
    
    class Section
      include Templette::DataAccessors
      attr_accessor :page
      
      def initialize(page, hash={})
        @page = page
        for k,v in hash
          generate_accessor(k, v)
        end
      end
      
    end 
  end   
    
end

