desc "Build an HTML project from template files"
task(:build) do
  if ENV['destination']
    Templette::Generator.new(ENV['destination']).run
  else
    Templette::Generator.new.run
  end
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
  
  desc "Generate empty page files based upon template= and names="
  task :page_yaml do
    unless ENV['template'] && ENV['names']
      puts "You must set template and names to run this task."
      return
    end
    require 'file_generator'
    FileGenerator.page_yaml(ENV['template'], ENV['names'])
  end
  
  desc "Generate an empty generator file with name=example"
  task :helper do
    unless ENV['name']
      puts "You must enter a name for your helper."
      return
    end
    require 'file_generator'
    FileGenerator.helper(ENV['name'])
  end 

end

task :default => :build