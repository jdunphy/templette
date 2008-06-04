namespace :gem do
  desc "Build the gem"
  task( :build => :clean ) { `gem build templette.gemspec` }

  desc "Clean build artifacts"
  task( :clean ) { FileUtils.rm_rf Dir['*.gem'] }    

end   

desc "Run the test suite."
task(:test) do
  require File.expand_path(File.dirname(__FILE__) + "/test/test_suite.rb")
end