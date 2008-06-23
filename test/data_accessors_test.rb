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
  
  def test_generate_accessor_should_add_methods
    generate_accessor(:foo, "bar")
    assert_equal "bar", foo
    generate_accessor('boo', 'foo')
    assert_equal 'foo', boo
  end
  
  def test_specific_helper_should_override_application_helper
    include_helpers(['default_helper', 'dynamic_helper'])
    assert defined?(footer_blurb)
    assert_equal footer_blurb, 'generated by helper method'
  end
  
end