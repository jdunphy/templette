require File.expand_path(File.dirname(__FILE__) + '/test_helper.rb')

class ErrorTest < Test::Unit::TestCase
  
  def test_error_message_should_be_informative
    page = Templette::Page.new(TEST_ROOT + '/pages/index.yml')
    error = Templette::PageError.new(page, "Bad things happened!")
    assert_equal "PageError - index: Bad things happened!", error.message
  end
  
end