require 'yaml'

TEMPLATE_DIR = 'templates'

class Template
    
  def initialize(name)
    @name = name
  end
  
  def to_html
    raise TemplateException.new("Template rendering failed.  File not found: #{@name}") unless File.exists?(path)
    File.read(path)
  end

  private
    def path
      "#{TEMPLATE_DIR}/#{@name}.html"
    end
end

class TemplateException < Exception
end