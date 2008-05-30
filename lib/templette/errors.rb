module Templette
  
  class TempletteError < Exception
    attr_accessor :error_source
    
    def initialize(error_source, message = nil)
      @message = message
      @error_source = error_source
    end
    
    def to_s
      "#{self.class.name.split('::').last} - #{error_source.name}: #{@message}"
    end
  end
  
  class TemplateError < TempletteError
  end
  
  class PageError < TempletteError
  end
  
end