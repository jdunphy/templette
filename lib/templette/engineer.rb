module Templette

  # The engineer is simply in charge of the engines.
  #
  # Additional templating languages can be supported by adding a class in the Templette::Engines
  # module which implements render(html, the_binding) in the templates/engines/ folder.  Name
  # the class the same as the 'type' for the template.
  
  module Engineer
    
    ENGINES_DIR = File.dirname(__FILE__) + "/engines/"
    
    @@engines = {}
    
    # Takes a string type and attempts to load a rendering engine of the same name.
    # If the Engine is found, an instance of the class will be returned.
    # A failure to find a matching engine file will result in a RenderError.
    
    def self.engine_for(type)
      load_engine(type)
    end
    
    def self.determine_type(filename)
      filename.match(/html\.?(\w+)?/)[1] || 'erb'
    end
    
    private 
    
      def self.load_engine(type)        
        unless @@engines[type]
          unless File.exists?(ENGINES_DIR + type + '.rb')
            raise RenderError.new("Rendering engine '#{type}' is not supported!")
          end
          begin
            require ENGINES_DIR + type
            @@engines[type] = Templette::Engines.const_get(type.capitalize)
          rescue
            raise RenderError.new("Rendering engine '#{type}' failed to load!")
          end
        end
        @@engines[type].new
      end
  end
end