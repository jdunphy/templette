namespace :gem do
  desc "Build the gem"
  task( :build => :clean ) { `gem build templette.gemspec` }

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

desc "Run the test suite."
task(:test) do
  require File.expand_path(File.dirname(__FILE__) + "/test/test_suite.rb")
end