desc "Build an HTML project from template files"
task(:build) do
  require 'rubygems'
  gem 'templette'
  require 'templette'
  Templette::Generator.new.run
end

namespace :generate do
  
  desc "Generate empty page files based upon TEMPLATE= and NAMES="
  task :page_yaml do
    unless ENV['TEMPLATE'] && ENV['NAMES']
      puts "You must set TEMPLATE AND NAMES to run this task."
      return
    end
    require 'rubygems'
    gem 'templette'
    require 'templette'
    template = Templette::Template.new(ENV['TEMPLATE'])
    ENV['NAMES'].split(/\s+/).each do |name|
      unless File.exists?("pages/#{name}.yml")
        File.open("pages/#{name}.yml", 'w') {|f| f << template.to_yaml }
      end
    end
  end
  
end

task :default => :build