GEM_ROOT = File.expand_path(File.dirname(__FILE__) + "/../") unless defined?(GEM_ROOT)

require 'test/unit'
require 'fileutils'
require GEM_ROOT + '/lib/templette'

class GeneratorTest  < Test::Unit::TestCase
  def test_should_generate_html_in_out_dir
    Templette::Generator.new.run
    file_content = File.open(GEM_ROOT + '/out/index.html') {|f| f.read}
    assert_match '<html>', file_content
    assert_match '</html>', file_content
    assert_match 'This is the content.', file_content
  end
  
  def teardown
    Dir.glob(GEM_ROOT + '/out/*').each do |f|
      FileUtils.rm(f)
    end
  end
end