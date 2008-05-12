GEM_ROOT = File.expand_path(File.dirname(__FILE__) + "/../") unless defined?(GEM_ROOT)

require 'test/unit'
require 'fileutils'
require GEM_ROOT + '/lib/templette'

class PageTest < Test::Unit::TestCase
  
  def test_init_bad_file
    page = Templette::Page.new(PAGES_DIR + '/nosuchfile.yml')
    flunk 'never threw exception for missing file'
  rescue Exception => e
    assert_match 'nosuchfile.yml', e.message
    assert_match 'missing page', e.message
  end
  
   def test_find_pages
     pages = Templette::Page.find
     assert_equal 1, pages.length
     assert_equal 'Home', pages.first.title.text
   end
  
  def test_generate_page
    FileUtils.mkdir('out') unless File.exists?('out')
    output_file = 'out/index.html'
    begin
      template = Templette::Template.new('main')
      page = Templette::Page.new(PAGES_DIR + '/index.yml')
      page.generate('out')
      assert File.exists?(output_file), 'output file was not generated'
      #should contain content from both the template and the page
      file_content = File.open(output_file) {|f| f.read}
      assert_match '<html>', file_content
      assert_match '</html>', file_content
      assert_match '<title>', file_content
      assert_match '</title>', file_content
      assert_match 'This is the content.', file_content
    ensure
      File.delete(output_file) if File.exists?(output_file)
    end
  end  
end
