require File.expand_path(File.dirname(__FILE__) + '/test_helper.rb')

class TempletteTest < Test::Unit::TestCase
  
  context "Templette" do
  
    setup do 
      File.stubs(:exists?).with('config.rb').returns(true)
      File.stubs(:read).with('config.rb').returns("Templette::config[:site_root] = '/foo/'")
    end
    
    should "use default settings if a file isn't loaded" do
      assert_equal '/', Templette.config[:site_root]
    end
    
    should "use a custom config when we #load_config_from_file" do
      Templette.load_config_from_file
      assert_equal '/foo/', Templette::config[:site_root]
    end
    
    teardown { Templette::config[:site_root] = '/'}
  end
  
end