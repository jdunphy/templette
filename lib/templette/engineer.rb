module Templette
  module Engineer
    
    ENGINES_DIR = File.dirname(__FILE__) + "/engines/"
    
    @@engines = {}
    
    def self.engine_for(type)
      load_engine(type)
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