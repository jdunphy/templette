require File.expand_path(File.dirname(__FILE__) + '/test_helper.rb')

class GeneratorTest < Test::Unit::TestCase
  
  context "Generator" do
    
    teardown { FileUtils.rm_rf(TEST_ROOT + "/out") if File.exist?(TEST_ROOT + "/out") }
    
    context "calling #run with default out dir" do
      
      setup { assert_successfully_generated { Templette::Generator.new.run } }
      
      should "generate html in out dir" do
        file_content = File.open(TEST_ROOT + '/out/index.html') {|f| f.read}
        assert_match '<html>', file_content
        assert_match '</html>', file_content
        assert_match 'This is the content.', file_content
      end
      
      should "generate html in subdirectories" do
        file_content = File.open(TEST_ROOT + '/out/subdir/index.html') {|f| f.read}
        assert_match '<html>', file_content
        assert_match '</html>', file_content
        assert_match 'This is the subdir/index content.', file_content
      end
      
      should "have happy feedback message" do
        assert_match "Site generation complete!", @output
      end
      
      should "copy resources" do
        assert File.exist?('resources/javascript/main.js')
        assert File.exist?('out/javascript/main.js')
      end
      
      should "not complain when resource are not present" do
        assert !File.exist?('no_such_resources')
        assert_successfully_generated { Templette::Generator.new('out', 'no_such_resources').run }
      end
      
    end
    
    context "calling #run with custom out dir" do
      setup do
        @out_dir = TEST_ROOT + '/nosuchdir'
        assert !File.exist?(@out_dir)
      end
        
      should "create out dir" do
        assert_successfully_generated { Templette::Generator.new(@out_dir).run }
        assert File.exist?(@out_dir)
      end
      
      teardown { FileUtils.rm_rf(@out_dir) if File.exist?(@out_dir) }
    end
    
    context "calling #run with custom site root" do
      setup do
        Templette::config[:site_root] = '/test/'
        assert_successfully_generated { Templette::Generator.new.run }
      end
      teardown { Templette::config[:site_root] = '/' }
      
      should "have good generation output" do
        assert_match "Generating site in: out/test", @output
        assert_match "Site generation complete!", @output
        assert_match "Copying resources from resources to out/test", @output
      end
      
      should "create expected files" do
        assert File.exists?(TEST_ROOT + '/out/test/index.html')
        assert File.exists?(TEST_ROOT + '/out/test/subdir/index.html')
      end
      
      should "copy over resources" do
        assert File.exist?(TEST_ROOT + '/out/test/javascript/main.js')
      end
    end
    
    context "calling #run with on a project with bad files" do
      setup {
        FileUtils.cp(TEST_ROOT + '/test_data/incomplete_sections.yml', TEST_ROOT + '/pages/incomplete_sections.yml')
      }
      teardown { FileUtils.rm(TEST_ROOT + '/pages/incomplete_sections.yml') }
      
      should "handle errors nicely" do
        output = capture_stdout { Templette::Generator.new.run }
        assert_match "SITE GENERATED WITH ERRORS!", output.string
        assert_match "No method 'image' defined in the yaml", output.string
      end
      
    end
    
    context "calling #clean" do
      setup do
        @out_dir = TEST_ROOT + '/out'
        @generator = Templette::Generator.new(@out_dir)
        capture_stdout { @generator.run }
        assert File.exists?(@out_dir)
      end
      
      should "remove out dir" do
        @generator.clean
        assert !File.exists?(@out_dir)
      end
    end    
  end
  
  private

    def assert_successfully_generated
      @output = capture_stdout { yield }.string
      assert_match "Site generation complete!", @output
      @output
    end
  
end