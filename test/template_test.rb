GEM_ROOT = File.expand_path(File.dirname(__FILE__) + "/../") unless defined?(GEM_ROOT)

require 'test/unit'
require GEM_ROOT + '/lib/template'
require 'fileutils'

class TemplateTest < Test::Unit::TestCase
  
  def test_should_return_template_html
    t = Template.new('main')
    assert_not_nil t.to_html
  end
  
  def test_should_raise_exception_if_file_not_found
    t = Template.new('four-oh-four')
    assert_raises(TemplateException) { t.to_html }
  end
end
