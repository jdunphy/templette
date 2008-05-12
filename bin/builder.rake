desc "Build an HTML project from template files"
task(:build) do
  require 'rubygems'
  gem 'templette'
  require 'templette'
  Templette::Generator.new.run
end

task :default => :build