GEM_ROOT = File.expand_path(File.dirname(__FILE__) + "/../") unless defined?(GEM_ROOT)

require 'test/unit'
require 'fileutils'
require GEM_ROOT + '/lib/templette'

Dir.chdir(GEM_ROOT)

class Test::Unit::TestCase 
  
  private
    def capture_stdout  #copied out of ZenTest and reduced
      require 'stringio'
      orig_stdout = $stdout.dup
      captured_stdout = StringIO.new
      $stdout = captured_stdout
      yield
      captured_stdout.rewind
      return captured_stdout
    ensure
      $stdout = orig_stdout
    end
end