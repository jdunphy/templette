desc "build an HTML project from template files"
task(:build) do
  require 'rubygems'
  gem 'templette'
  require 'generator'
  Generator.new.run
end

task :default => :build