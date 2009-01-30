require 'rake'
require 'rake/rdoctask'
require 'rake/testtask'

namespace :gem do
  
  desc "Build the gem"
  task( :build => :clean ) { system('gem build templette.gemspec') }

  desc "Clean build artifacts"
  task( :clean ) { FileUtils.rm_rf Dir['*.gem'] }    

  desc "Install the gem"
  task(:install => [:build, :uninstall]) do
    system('sudo gem install templette')
  end

  task(:uninstall) do
    system('sudo gem uninstall templette')
  end

end   

Rake::TestTask.new do |t|
  t.libs << "."
  t.verbose = true
  t.pattern = 'test/*_test.rb'
end

desc 'Generate documentation for templette.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = 'Templette'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc 'Publish rdoc'
task( :rdoc_publish => :rdoc ) do
  `rsync -a --delete ./doc/ jdunphy@rubyforge.org:/var/www/gforge-projects/templette/`
end

task :default => :test
