module Templette
  module Engines
    class Erb
    
      def render(html, the_binding)
        ERB.new(html, 0, "%<>").result(the_binding)
      end
      
    end
  end
end