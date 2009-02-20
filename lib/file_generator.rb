require File.dirname(__FILE__) + '/templette'
module FileGenerator
    
  class << self
    
    # Called by rake generate:page template=<name> names="<file1 file2>"
    #
    # Generates empty page yaml files in /pages.  Takes the methods called in the template and turns them into a yaml framework.
    def page_yaml(template, names)
      template = Templette::Template.new(template)
      names.split(/\s+/).each do |name|
        filename = "pages/#{name}.yml"
        unless File.exists?(filename)
          FileUtils.mkdir_p(File.dirname(filename))
          File.open(filename, 'w') {|f| f << template.to_yaml }
        end
      end
    end
  
    # Called by rake generate:helper name=<template_name>
    #
    # Generates a helper module in /helpers.  A helper will be loaded if it shares the name of the template being applied.
    # To load a different helper, you'll have to include it in default_helper.
    def helper(name)
      helper_name = name =~ /_helper\Z/ ? name : "#{name}_helper"
      module_name = helper_name.split('_').map{|str| str.capitalize}.join
      File.open("helpers/#{helper_name}.rb", 'w') do |f|
        f << "module #{module_name}
  # Add methods for the #{name} template here
end"
      end
    end
    
    def config
      if File.exists?("config.rb")
        puts 'Config file already exists!'
      else
        File.open("config.rb", 'w') do |f|
          f << "# A site root can be set like this
# Templette::config[:site_root] = '/new_root/'"
        end
      end
    end
  end
  
end