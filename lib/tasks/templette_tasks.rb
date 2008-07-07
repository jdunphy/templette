desc "Build an HTML project from template files"
task(:build) do
  Templette::Generator.new(ENV['destination']).run
end

desc "Remove all generated files"
task :clean do
  Templette::Generator.new.clean
end

namespace :cap do
  
  desc "Install the basic capistrano recipes and Capfile"
  task :install do
    files_dir = File.dirname(__FILE__) + '/../../files/'
    %w{Capfile deploy.rb}.each do |file|
      FileUtils.cp(files_dir + file, file) unless File.exists?(file)
    end
  end
  
end

namespace :generate do
  
  desc "Generate empty page files based upon TEMPLATE= and NAMES="
  task :page_yaml do
    unless ENV['TEMPLATE'] && ENV['NAMES']
      puts "You must set TEMPLATE AND NAMES to run this task."
      return
    end
    require 'file_generator'
    FileGenerator.page_yaml(ENV['TEMPLATE'], ENV['NAMES'])
  end
  
  desc "Generate an empty generator file with NAME=example"
  task :helper do
    unless ENV['NAME']
      puts "You must enter a name for your helper."
      return
    end
    require 'file_generator'
    FileGenerator.helper(ENV['NAME'])
  end 

end

task :default => :build