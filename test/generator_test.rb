require File.expand_path(File.dirname(__FILE__) + '/test_helper.rb')

class GeneratorTest < Test::Unit::TestCase
  def test_should_generate_html_in_out_dir
    assert_successfully_generated { Templette::Generator.new.run }    
    file_content = File.open(GEM_ROOT + '/out/index.html') {|f| f.read}
    assert_match '<html>', file_content
    assert_match '</html>', file_content
    assert_match 'This is the content.', file_content
  end
  
  def test_should_create_out_dir_if_doesnt_exist
    out_dir = GEM_ROOT + '/nosuchdir'
    assert !File.exist?(out_dir)
    begin
      assert_successfully_generated { Templette::Generator.new(out_dir).run }
      assert File.exist?(out_dir)
    ensure
      FileUtils.rm_rf(out_dir) if File.exist?(out_dir)
    end
  end
  
  def test_should_print_success_message
    assert_match "Site generation complete!", capture_stdout { Templette::Generator.new.run }.string
  end
  
  def test_should_handle_errors_nicely    
    FileUtils.cp(GEM_ROOT + '/test_data/incomplete_sections.yml', GEM_ROOT + '/pages/incomplete_sections.yml')
    output = capture_stdout { Templette::Generator.new.run }
    assert_match "SITE GENERATED WITH ERRORS!", output.string
    assert_match " * No method 'image' defined in the yaml", output.string
  ensure
    FileUtils.rm(GEM_ROOT + '/pages/incomplete_sections.yml')
  end
  
  def teardown
    Dir.glob(GEM_ROOT + '/out/*').each do |f|
      FileUtils.rm(f)
    end
    FileUtils.rm_rf(GEM_ROOT + '/out') if File.exist?(GEM_ROOT + '/out')
  end
  
  private

    def assert_successfully_generated
      output = capture_stdout { yield }
      assert_match "Site generation complete!", output.string
    end
  
end