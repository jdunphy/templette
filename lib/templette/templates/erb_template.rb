module Templette
  class ErbTemplate
    
    def do_render(html, the_binding)
      ERB.new(html, 0, "%<>").result(the_binding)
    end
    
  end
end