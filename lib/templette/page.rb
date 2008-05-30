require 'yaml'
require 'ostruct'
require 'erb'

PAGES_DIR = 'pages'
module Templette

  class Page < OpenStruct
    attr_accessor :name, :template
  
    def self.find
      files = Dir["#{PAGES_DIR}/*.yml"]
      files.map {|f| Page.new(f) }
    end
  
    def initialize(page_config)
      raise PageError.new(self, "missing page #{page_config}") unless File.exists?(page_config)
      # TODO(sholder) is this legit?  Will YAML close the file when its done?
      data = YAML::load_file(page_config)
      @name = File.basename(page_config, '.yml')
      raise PageError.new(self, "missing required section \"template_name\" for page config #{page_config}")unless data['template_name']
      @template = Template.new(data['template_name'])

      raise PageError.new(self, "missing sections in yml for page config #{page_config}") unless data['sections']
      @table = {}
      data['sections'].each_pair do |k,v|
        v = Section.new(self, v) if v.kind_of?(Hash)
        @table[k.to_sym] = v
        new_ostruct_member(k)
      end
    end
  
    def output_file_name(out_dir)
      "#{out_dir}/#{@name}.html"
    end
  
    def generate(out_dir)
      File.open(output_file_name(out_dir), 'w') do |f| 
        f << ERB.new(@template.to_html, 0, "%<>").result(binding)
      end
    end  
    
    class Section < OpenStruct
      def initialize(page, hash={})
        @page = page
        @table = {}
        for k,v in hash
          if v.kind_of?(Hash)
            v = Section.new(@page, v)
          elsif v =~ /file:(.*)/
            v = File.open($1) {|f| f.read}
          end
          @table[k.to_sym] = v
          new_ostruct_member(k)
        end
      end
      
      def method_missing(symbol)  
        raise PageError.new(@page, "No method '#{symbol}' defined in the yaml")
      end
    end 
  end   
    
end

