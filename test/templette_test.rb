require File.expand_path(File.dirname(__FILE__) + '/test_helper.rb')

class TempletteTest < Test::Unit::TestCase
  
  def test_generic_config_settings
    assert_equal '/', Templette.config[:site_root]
  end
  
  def test_loading_custom_config
    File.expects(:exists?).with('config.rb').returns(true)
    File.expects(:read).with('config.rb').returns("Templette::config[:site_root] = '/foo/'")
    Templette.load_config_from_file
    assert_equal '/foo/', Templette::config[:site_root]
  end
  
  def teardown
    Templette::config[:site_root] = '/'
  end
end