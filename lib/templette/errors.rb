module Templette
  
  class TempletteError < Exception
  end
  
  class TemplateException < TempletteError
  end
  
  class PageException < TempletteError
  end
  
end