require 'haml'

module Templette
  module Engines
    class Haml
    
      def render(html, the_binding)
        with_no_warnings { ::Haml::Engine.new(html).render(the_binding) }
      end
      
      
      def with_no_warnings
        save = $-w
        $-w = false

        begin
          yield
        ensure
          $-w = save
        end
      end
      
    end
  end
end