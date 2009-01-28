require 'haml'

module Templette
  class Haml
    
    def do_render(html, the_binding)
      ::Haml::Engine.new(html).render(the_binding)
    end
    
  end
end