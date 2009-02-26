require File.expand_path(File.dirname(__FILE__) + '/test_helper.rb')
require GEM_ROOT + '/lib/file_generator'

class FileGeneratorTest < Test::Unit::TestCase
  
  def self.should_generate_yaml_file(name)
    should "generate yaml file" do
      assert File.exists?(@file_path)
    end

    should "have template name" do
      page_yaml = YAML.load_file(@file_path)
      assert_equal name, page_yaml['template_name']
    end

    should "generate expected yaml file" do
      page_yaml = YAML.load_file(@file_path)
      assert_not_nil page_yaml['sections']
      assert page_yaml['sections'].kind_of?(Hash)
      assert page_yaml['sections']['title'].kind_of?(Hash)
    end
  end
  
  context "generating a helper" do
    setup do
      @file_path = TEST_ROOT + '/helpers/foo_helper.rb'
      FileGenerator.helper('foo')
    end
    teardown { FileUtils.rm(@file_path) if File.exists?(@file_path) }
    
    should "create the file" do
      assert File.exists?(@file_path)
    end
    
    should "contain a helper module" do
      helper_contents = File.read(@file_path)
      assert_match "module FooHelper", helper_contents
    end
  end
  
  context "generating page yaml" do

    teardown { FileUtils.rm(@file_path) if File.exists?(@file_path) }
    
    context "with a simple case" do
      setup do
        @file_path = TEST_ROOT + '/pages/test.yml'
        FileGenerator.page_yaml('main', 'test')
      end
      should_generate_yaml_file('main')
    end    
    
    context "with a subdirectory" do
      setup do
        @file_path = TEST_ROOT + '/pages/new-subdir/test.yml'
        FileGenerator.page_yaml('main', 'new-subdir/test')
      end
      should_generate_yaml_file('main')
      
      teardown { FileUtils.rm_rf(TEST_ROOT + '/pages/new-subdir') }
    end
    
    context "with haml" do
      setup do
        @file_path = TEST_ROOT + '/pages/hammy-test.yml'
        FileGenerator.page_yaml('hammy', 'hammy-test')
      end
      should_generate_yaml_file('hammy')
    end
  end
  
  context "generating a config file" do
    setup { @file_path = TEST_ROOT + '/config.rb' }
    teardown { FileUtils.rm(@file_path) if File.exists?(@file_path) }
    
    should "generate a config file as expected" do
      FileGenerator.config
      assert File.exists?(@file_path)
      assert_match /# Templette::config\[:site_root\] =/, File.read(@file_path)
      assert_match /# Templette::config\[:default_engine\] =/, File.read(@file_path)
    end
    
    should "not overwrite an existing config file" do
      File.open(@file_path, 'w') {|f| f << "# In the config file" }
      output = capture_stdout { FileGenerator.config}.string
      assert_match /In the config file/, File.read(@file_path)
      assert_match /Config file already exists!/, output
    end
  end
  
end
