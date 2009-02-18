require File.expand_path(File.dirname(__FILE__) + '/test_helper.rb')

class DataAccessorsTest < Test::Unit::TestCase
  
  include Templette::DataAccessors
  
  def test_should_add_helper
    assert !defined?(footer_blurb)
    require 'helpers/dynamic_helper'
    add_helper('dynamic_helper')
    assert defined?(footer_blurb)
    assert_equal 'generated by helper method', footer_blurb
  end
  
  def test_include_helpers
    assert !defined?(footer_blurb)
    assert !defined?(application_helper_method)
    include_helpers(['default_helper', 'dynamic_helper'])
    assert defined?(footer_blurb)
    assert defined?(application_helper_method)
  end
  
  def test_specific_helper_should_override_application_helper
    include_helpers(['default_helper', 'dynamic_helper'])
    assert defined?(footer_blurb)
    assert_equal footer_blurb, 'generated by helper method'
  end
  
  #We can test private methods, since we're including the module!
  def test_generate_accessor_should_add_methods
    assert !defined?(foo)
    generate_accessor(:foo, "bar")
    assert_equal "bar", foo
    assert !defined?(boo)
    generate_accessor('boo', 'foo')
    assert_equal 'foo', boo
  end
  
  def test_generate_accessors_should_add_methods
    assert !defined?(foo)
    assert !defined?(boo)
    generate_accessors({:foo => 'bar', 'boo' => 'foo'})
    assert_equal "bar", foo
    assert_equal 'foo', boo
  end
  
  def test_generate_accessors_with_render_colon_should_make_method_that_calls_partial
    self.expects(:partial).returns("partial string")
    generate_accessors :file_node => 'render:foo.html.haml'
    file_node
  end
  
  def test_generate_accessors_with_render_space_should_make_method_that_calls_partial
    self.expects(:partial).returns("partial string")
    generate_accessors :file_node => 'render foo.html.haml'
    file_node    
  end
  
  def test_generate_accessors_should_raise_error_if_missing_file_is_requested
    self.expects(:page).returns(stub('page_object', :name => 'FAKE PAGE'))
    error = assert_raise(Templette::PageError) { generate_accessors :file_node => 'file:404esque.html'}
    assert_equal 'PageError - FAKE PAGE: File requested by :file_node no found!', error.to_s
  end
  
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
  
  def test_tags_with_set_site_root
    Templette::config[:site_root] = '/subdir/'
    assert_equal "<img src='/subdir/images/foo.jpg' alt='foo.jpg' />", image_tag('foo.jpg')
    assert_equal "<link href='/subdir/stylesheets/main.css' type='text/css' />", stylesheet_tag('main')
    assert_equal "<script src='/subdir/javascripts/application.js' type='text/javascript'></script>", script_tag('application')
  ensure
    Templette::config[:site_root] = '/'
  end
  
  def test_tags_with_http_protocol_dont_get_modified
    assert_equal "<img src='http://foo.com/images/foo.jpg' alt='foo' />", image_tag('http://foo.com/images/foo.jpg', :alt => 'foo')
    assert_equal "<link href='http://foo.com/stylesheets/main.css' type='text/css' />", stylesheet_tag('http://foo.com/stylesheets/main.css')
    assert_equal "<script src='http://foo.com/lib.js' type='text/javascript'></script>", script_tag('http://foo.com/lib.js')
  end
  
end