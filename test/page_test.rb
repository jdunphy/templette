require File.expand_path(File.dirname(__FILE__) + '/test_helper.rb')

class PageTest < Test::Unit::TestCase
  
  def test_init_no_such_file
    page = Templette::Page.new(PAGES_DIR + '/nosuchfile.yml')
    flunk 'never threw exception for missing file'
  rescue Exception => e
    assert e.kind_of?(Templette::PageError)
    assert_match 'nosuchfile.yml', e.message
    assert_match 'missing page', e.message
  end
  
  def test_init_page_config_missing_template_name
    page = Templette::Page.new('test_data/missing_template_name.yml')
    flunk 'never threw exception for missing required section'
  rescue Exception => e
    assert e.kind_of?(Templette::PageError)
    assert_match 'missing_template_name.yml', e.message
    assert_match '"template_name"', e.message
  end
  
  def test_init_page_missing_sections
    page = Templette::Page.new('test_data/missing_sections.yml')
    flunk 'never threw exception for missing required sections'
  rescue Exception => e
    assert e.kind_of?(Templette::PageError)
    assert_match 'missing_sections.yml', e.message
    assert_match 'missing sections', e.message
  end
  
  def test_init_page_invalid_yml
    page = Templette::Page.new('test_data/bad_config.xml')
    flunk 'never threw exception for a non-yml file'
  rescue Exception => e
    assert e.kind_of?(Templette::PageError)
    assert_match 'bad_config.xml', e.message
  end
  
  def test_find_pages
     pages = Templette::Page.find
     assert_equal 1, pages.length
     assert_equal 'Home', pages.first.title.text
  end       
  
  def test_incomplete_yaml
    page = Templette::Page.new('test_data/incomplete_sections.yml')
    assert_not_nil page
    assert_raises(Templette::PageError) { page.generate('out') }
    begin 
      page.generate('out')
    rescue Templette::PageError => e
      assert_equal "PageError - incomplete_sections: No method 'image' defined in the yaml", e.message
    end
  end
  
  def test_initialization_loads_sections_and_creates_methods
    page = Templette::Page.new(PAGES_DIR + '/index.yml')
    assert_equal 'Home', page.title.text
    assert_equal 'Home', page.title.text
    assert_equal '/images/whatever.jpg', page.inline.title.image
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
  
  def test_generate_page_with_helper_method
    expected_content = 'generated by helper method'
    IndexHelper.init(expected_content)
    FileUtils.mkdir('out') unless File.exists?('out')
    output_file = 'out/index.html'
    begin
      template = Templette::Template.new('dynamic')
      page = Templette::Page.new(PAGES_DIR + '/index.yml')
      page.generate('out', template)
      assert File.exists?(output_file), 'output file was not generated'
      #should contain content from generated from method calls
      file_content = File.open(output_file) {|f| f.read}
      assert_match expected_content, file_content
      assert IndexHelper.was_method_called?
    ensure
      File.delete(output_file) if File.exists?(output_file)
    end
  end
  end
