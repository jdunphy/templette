require File.expand_path(File.dirname(__FILE__) + '/test_helper.rb')
require GEM_ROOT + '/lib/file_generator'

class FileGeneratorTest < Test::Unit::TestCase
  
  def test_helper_gerator_should_create_file
    file_path = TEST_ROOT + '/helpers/foo_helper.rb'
    assert !File.exists?(file_path)
    FileGenerator.helper('foo')
    assert File.exists?(file_path)
  ensure  
    FileUtils.rm(file_path) if File.exists?(file_path)
  end
  
  def test_generated_helper_file_should_contain_helper_module
    file_path = TEST_ROOT + '/helpers/foo_helper.rb'
    FileGenerator.helper('foo')
    helper_contents = File.read(file_path)
    assert_match "module FooHelper", helper_contents
  ensure  
    FileUtils.rm(file_path) if File.exists?(file_path)  
  end
  
  def test_should_generate_page_yaml_file
    file_path = TEST_ROOT + '/pages/test.yml'
    FileGenerator.page_yaml('main', 'test')
    assert File.exists?(file_path)
  ensure
    FileUtils.rm(file_path) if File.exists?(file_path)  
  end
  
  def test_generated_page_should_include_generated_yaml
    file_path = TEST_ROOT + '/pages/test.yml'
    FileGenerator.page_yaml('main', 'test')
    page_yaml = YAML.load_file(file_path)
    assert_not_nil page_yaml['sections']
    assert page_yaml['sections'].kind_of?(Hash)
    assert page_yaml['sections']['title'].kind_of?(Hash)
  ensure
    FileUtils.rm(file_path) if File.exists?(file_path)  
  end
  
  def test_generate_page_should_include_template_name
    file_path = TEST_ROOT + '/pages/test.yml'
    FileGenerator.page_yaml('main', 'test')
    page_yaml = YAML.load_file(file_path)
    assert_equal 'main', page_yaml['template_name']
  ensure
    FileUtils.rm(file_path) if File.exists?(file_path)    
  end
  
  def test_generate_page_should_handle_directory_depth
    file_path = TEST_ROOT + '/pages/new-subdir/test.yml'
    FileGenerator.page_yaml('main', 'new-subdir/test')
    assert File.exists?(file_path)
  ensure  
    FileUtils.rm(file_path) if File.exists?(file_path)
    FileUtils.rm_rf(TEST_ROOT + '/pages/new-subdir') 
  end
  
end
