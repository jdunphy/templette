module Templette
  module DataAccessors
    def attributes # :nodoc:
      @attributes ||= {}
    end
    
    def generate_accessors(accessors = {}) # :nodoc:
      accessors.each_pair { |k,v| generate_accessor(k, v) }
    end
        
    def include_helpers(helpers) # :nodoc:
      helpers.each { |helper| add_helper(helper) }
    end
    
    def method_missing(symbol) # :nodoc:
      raise PageError.new(page, "No method '#{symbol}' defined in the yaml")
    end
    
    def partial(filename) # :nodoc:
      raise PageError.new(page, "Rendering #{filename} failed.  File not found.") unless File.exists?(filename)
      Engineer.engine_for(Engineer.determine_type(filename)).render(File.read(filename), page._binding)
    rescue RenderError => e
      raise PageError.new(page, e.message)      
    end

    # Generates an image tag.  Default options {:alt => filename }
    # 
    # Ex. 
    #    image_tag('ball.png', :alt => 'a red ball')
    #    => "<img src='/images/ball.png' alt='a red ball' />"
    
    def image_tag(path, options = {})
      options = {:alt => path}.merge(options)
      "<img src='/images/#{path}' #{params_to_attributes(options)}/>"
    end
    
    # Generates a link to a stylesheet.  Default options {:type => 'text/css'}
    # 
    # Ex. 
    #    stylesheet_tag('print', :media => 'print')
    #    => "<link href='/stylesheets/print.css' media='print' type='text/css' />"
    
    def stylesheet_tag(path, options = {})
      options = {:type => 'text/css'}.merge(options)
      "<link href='/stylesheets/#{path}.css' #{params_to_attributes(options)}/>"
    end
    
    # Genrates a javascript scrip tag.
    #
    # Ex.
    #     script_tag('slider')
    #     => <script src='/javascripts/slider.js' type='text/javascript'></script>
    
    def script_tag(path)
      "<script src='/javascripts/#{path}.js' type='text/javascript'></script>"
    end
    
    private
    
      def params_to_attributes(options)
        options.inject('') do |str, h|
          str << "#{h[0]}='#{h[1]}' "
        end
      end
    
      def generate_accessor(k, v)
        raise TempletteError.new(page, "Method already defined: #{k}.  Change your config file and stop using it!") if self.methods.include?(k.to_s)
        if v.kind_of?(Hash)
          v = Page::Section.new(page, v)
        elsif v =~ /file:(.*)/
          raise PageError.new(page, "File requested by :#{k} no found!") unless File.exists?($1)
          v = File.open($1) {|f| f.read}
        elsif v.nil?
          v = Page::Section.new(page, {})
        elsif v =~/render[:\ ](.*)/
          instance_eval "
          def #{k.to_s}
            partial '#{$1.strip}'
          end"
         return
        end
        attributes[k.to_s] = v
        instance_eval "def #{k.to_s}; attributes['#{k.to_s}']; end"
      end

      def add_helper(helper)
        if File.exists?("helpers/#{helper}.rb")
          require "helpers/#{helper}" 
          extend Object.module_eval("::#{helper.split('_').map {|str| str.capitalize}.join}", __FILE__, __LINE__)
        end
      end
  end
end