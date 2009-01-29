require 'haml'

module Templette
  module Engines
    class Haml
    
      def render(html, the_binding)
        ::Haml::Engine.new(html).render(the_binding)
      end
    
    end
  end
end