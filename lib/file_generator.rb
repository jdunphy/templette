require File.dirname(__FILE__) + '/templette'
module FileGenerator
  
  def self.page_yaml(template, names)
    template = Templette::Template.new(template)
    names.split(/\s+/).each do |name|
      unless File.exists?("pages/#{name}.yml")
        File.open("pages/#{name}.yml", 'w') {|f| f << template.to_yaml }
      end
    end
  end
  
  def self.helper(name)
    helper_name = name =~ /_helper\Z/ ? name : "#{name}_helper"
    module_name = helper_name.split('_').map{|str| str.capitalize}.join
    File.open("helpers/#{helper_name}.rb", 'w') do |f|
      f << "module #{module_name}
  # Add methods for the #{name} template here
end"
    end
  end
  
end