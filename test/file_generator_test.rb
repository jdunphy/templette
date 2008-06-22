require File.expand_path(File.dirname(__FILE__) + '/test_helper.rb')
require GEM_ROOT + '/lib/file_generator'

class FileGeneratorTest < Test::Unit::TestCase
  
  def setup
    @file_path = GEM_ROOT + '/helpers/foo_helper.rb'
  end
  
  def test_helper_gerator_should_create_file
    assert !File.exists?(@file_path)
    FileGenerator.helper('foo')
    assert File.exists?(@file_path)
  ensure  
    FileUtils.rm(@file_path) if File.exists?(@file_path)
  end
  
  def test_generated_helper_file_should_contain_helper_module
    FileGenerator.helper('foo')
    helper_contents = File.read(@file_path)
    assert_match "module FooHelper", helper_contents
  ensure  
    FileUtils.rm(@file_path) if File.exists?(@file_path)  
  end
  
  
end
