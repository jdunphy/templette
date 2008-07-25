require File.dirname(__FILE__) + '/templette'
module FileGenerator
    
  class << self
    
    # Called by rake generate:page TEMPLATE=<name> NAMES="<file1 file2>"
    #
    # Generates empty page yaml files in /pages.  Takes the methods called in the template and turns them into a yaml framework.
    def page_yaml(template, names)
      template = Templette::Template.new(template)
      names.split(/\s+/).each do |name|
        unless File.exists?("pages/#{name}.yml")
          File.open("pages/#{name}.yml", 'w') {|f| f << template.to_yaml }
        end
      end
    end
  
    # Called by rake generate:helper NAME=<template_name>
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
  end
  
end