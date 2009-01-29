module Templette
  module Engineer
    
    ENGINES_DIR = File.dirname(__FILE__) + "/engines/"
    
    @@engines = {
      'erb' =>  { :loaded => false },
      'haml' => { :loaded => false }
    }
    
    def self.create_engine(type)
      load_engine(type)
    end
    
    private 
    
      def self.load_engine(type)
        engine = @@engines[type]
        raise RenderError.new("Rendering engine #{type} is not supported!") unless engine
        if engine[:loaded] != true
          require ENGINES_DIR + type
          engine[:class] = Templette::Engines.const_get(type.capitalize)
          engine[:loaded] = true
        end
        engine[:class].new
      end
  end
end