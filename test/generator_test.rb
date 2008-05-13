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
  
  def test_should_create_out_dir_if_doesnt_exist
    out_dir = GEM_ROOT + '/nosuchdir'
    assert !File.exist?(out_dir)
    begin
      Templette::Generator.new(out_dir).run
      assert File.exist?(out_dir)
    ensure
      FileUtils.rm_rf(out_dir) if File.exist?(out_dir)
    end
  end
  
  def teardown
    Dir.glob(GEM_ROOT + '/out/*').each do |f|
      FileUtils.rm(f)
    end
  end
end