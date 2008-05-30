require File.expand_path(File.dirname(__FILE__) + '/test_helper.rb')

class TemplateTest < Test::Unit::TestCase
  
  def test_should_return_template_html
    t = Templette::Template.new('main')
    assert_not_nil t.to_html
  end
  
  def test_should_raise_exception_if_file_not_found
    t = Templette::Template.new('four-oh-four')
    assert_raises(Templette::TemplateError) { t.to_html }
  end
  
  def test_should_have_informative_error_message
    t = Templette::Template.new('four-oh-four')
    begin
      t.to_html
    rescue Exception => e
      assert_equal "TemplateError - four-oh-four: Template rendering failed.  File not found.", e.message
    end
  end
end
