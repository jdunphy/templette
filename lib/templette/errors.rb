module Templette
  class TempletteError < StandardError
    
    def initialize(error_source, message = nil)
      @error_source = error_source
      @message = message
    end
    
    def to_s
      "#{self.class.name.split('::').last} - #{@error_source.name}: #{@message}"
    end
  end
  
  class TemplateError < TempletteError  # :nodoc:
  end
  
  class PageError < TempletteError  # :nodoc:
  end
  
end
