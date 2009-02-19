require File.expand_path(File.dirname(__FILE__) + '/test_helper.rb')

class GeneratorTest < Test::Unit::TestCase
  def test_should_generate_html_in_out_dir
    assert_successfully_generated { Templette::Generator.new.run }    
    file_content = File.open(TEST_ROOT + '/out/index.html') {|f| f.read}
    assert_match '<html>', file_content
    assert_match '</html>', file_content
    assert_match 'This is the content.', file_content
  end
  
  def test_should_generate_html_in_out_dir_subirectories
    assert_successfully_generated { Templette::Generator.new.run }    
    file_content = File.open(TEST_ROOT + '/out/subdir/index.html') {|f| f.read}
    assert_match '<html>', file_content
    assert_match '</html>', file_content
    assert_match 'This is the subdir/index content.', file_content
  end
  
  def test_should_create_out_dir_if_doesnt_exist
    out_dir = TEST_ROOT + '/nosuchdir'
    assert !File.exist?(out_dir)
    begin
      assert_successfully_generated { Templette::Generator.new(out_dir).run }
      assert File.exist?(out_dir)
    ensure
      FileUtils.rm_rf(out_dir) if File.exist?(out_dir)
    end
  end
  
  def test_clean_should_remove_out
    out_dir = TEST_ROOT + '/out'
    t = Templette::Generator.new(out_dir)
    capture_stdout { t.run }
    assert File.exists?(out_dir)
    t.clean
    assert !File.exists?(out_dir)
  end
  
  def test_should_print_success_message
    assert_match "Site generation complete!", capture_stdout { Templette::Generator.new.run }.string
  end
  
  def test_should_handle_errors_nicely    
    FileUtils.cp(TEST_ROOT + '/test_data/incomplete_sections.yml', TEST_ROOT + '/pages/incomplete_sections.yml')
    output = capture_stdout { Templette::Generator.new.run }
    assert_match "SITE GENERATED WITH ERRORS!", output.string
    assert_match "No method 'image' defined in the yaml", output.string
  ensure
    FileUtils.rm(TEST_ROOT + '/pages/incomplete_sections.yml')
  end

  def test_should_copy_from_resources
    assert File.exist?('resources/javascript/main.js')
    assert_successfully_generated { Templette::Generator.new.run }
    assert File.exist?('out/javascript/main.js')
  end

  def test_should_not_complain_when_resources_not_present
    assert !File.exist?('no_such_resources')
    assert_successfully_generated { Templette::Generator.new('out', 'no_such_resources').run }
  end
  
  def test_should_generate_site_into_custom_site_root
    Templette::config[:site_root] = '/test/'
    output = capture_stdout { Templette::Generator.new.run }.string 
    assert_match "Generating site in: out/test", output
    assert_match "Site generation complete!", output
    assert_match "Copying resources from resources to out/test", output
    assert File.exists?(TEST_ROOT + '/out/test/index.html')
    assert File.exists?(TEST_ROOT + '/out/test/subdir/index.html')
    assert File.exist?(TEST_ROOT + '/out/test/javascript/main.js')
    
  ensure
    Templette::config[:site_root] = '/'
  end

  def teardown
    FileUtils.rm_rf(TEST_ROOT + "/out") if File.exist?(TEST_ROOT + "/out")
  end
  
  private

    def assert_successfully_generated
      output = capture_stdout { yield }
      assert_match "Site generation complete!", output.string
    end
  
end