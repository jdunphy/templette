module Templette
  module Engineer
    
    ENGINES_DIR = File.dirname(__FILE__) + "/engines/"
    
    @@engines = {
      'erb' =>  { :loaded => false },
      'haml' => { :loaded => false }
    }
    
    def self.handle_render(type, template, the_binding)
      engine = load_engine(type)
      engine.do_render(template, the_binding)
    end
    
    private 
    
      def self.load_engine(type)
        engine = @@engines[type]
        raise RenderError.new("Rendering engine #{type} is not supported!") unless @@engines.has_key?(type)
        if engine[:loaded] != true
          require ENGINES_DIR + type
          engine[:class] = Templette.const_get(type.capitalize)
          engine[:loaded] = true
        end
        engine[:class].new
      end
  end
end