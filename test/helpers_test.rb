require File.expand_path(File.dirname(__FILE__) + '/test_helper.rb')

class HelpersTest < Test::Unit::TestCase
  
  include Templette::Helpers
  
  def test_image_tag
    assert_equal "<img src='/images/foo.jpg' alt='foo.jpg' />", image_tag('foo.jpg')
    assert_equal "<img src='/images/foo.jpg' alt='a foo' />", image_tag('foo.jpg', :alt => 'a foo')
  end

  def test_stylesheet_tag
    assert_equal "<link href='/stylesheets/main.css' type='text/css' />", stylesheet_tag('main')
    assert_match "media='screen'", stylesheet_tag('main', :media => 'screen')
    assert_match "type='text/css'", stylesheet_tag('main', :media => 'screen')
  end

  def test_script_tag
    assert_equal "<script src='/javascripts/application.js' type='text/javascript'></script>", script_tag('application')
  end

  context "A set site root" do
    setup { Templette::config[:site_root] = '/subdir/' }
  
    should "affect image tags" do 
      assert_equal "<img src='/subdir/images/foo.jpg' alt='foo.jpg' />", image_tag('foo.jpg')
    end
  
    should "affect stylesheet tag" do
      assert_equal "<link href='/subdir/stylesheets/main.css' type='text/css' />", stylesheet_tag('main')
    end
  
    should "affect javascript tag" do
      assert_equal "<script src='/subdir/javascripts/application.js' type='text/javascript'></script>", script_tag('application')
    end
  
    teardown { Templette::config[:site_root] = '/'}
  end


  def test_tags_with_http_protocol_dont_get_modified
    assert_equal "<img src='http://foo.com/images/foo.jpg' alt='foo' />", image_tag('http://foo.com/images/foo.jpg', :alt => 'foo')
    assert_equal "<link href='http://foo.com/stylesheets/main.css' type='text/css' />", stylesheet_tag('http://foo.com/stylesheets/main.css')
    assert_equal "<script src='http://foo.com/lib.js' type='text/javascript'></script>", script_tag('http://foo.com/lib.js')
  end
  
end