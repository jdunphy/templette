require File.expand_path(File.dirname(__FILE__) + '/test_helper.rb')

class PageTest < Test::Unit::TestCase
  
  def teardown
    reset_pages_dir
  end
  
  def test_init_no_such_file
    page = Templette::Page.new(Templette::Page.pages_dir + '/nosuchfile.yml')
    flunk 'never threw exception for missing file'
  rescue Exception => e
    assert e.kind_of?(Templette::PageError)
    assert_match 'nosuchfile.yml', e.message
    assert_match 'missing page', e.message
  end
  
  def test_init_page_config_missing_template_name
    set_pages_dir 'test_data/'
    page = Templette::Page.new('test_data/missing_template_name.yml')
    flunk 'never threw exception for missing required section'
  rescue Exception => e
    assert e.kind_of?(Templette::PageError)
    assert_match 'missing_template_name.yml', e.message
    assert_match '"template_name"', e.message
  end
  
  def test_init_page_missing_sections
    set_pages_dir 'test_data/'
    page = Templette::Page.new('test_data/missing_sections.yml')
    flunk 'never threw exception for missing required sections'
  rescue Exception => e
    assert e.kind_of?(Templette::PageError)
    assert_match 'missing_sections.yml', e.message
    assert_match 'missing sections', e.message
  end
  
  def test_rendering_page_catches_and_raises_missing_methods
    set_pages_dir 'test_data/'
    page = Templette::Page.new('test_data/nil_section.yml')
    page.generate('out')
    flunk 'never threw exception for missing section'
  rescue Exception => e
    assert e.kind_of?(Templette::PageError)
    assert_match 'nil_section', e.message
    assert_match "No method 'title'", e.message
  end
  
  def test_init_page_invalid_yml
    page = Templette::Page.new('test_data/bad_config.xml')
    flunk 'never threw exception for a non-yml file'
  rescue Exception => e
    assert e.kind_of?(Templette::PageError)
    assert_match 'bad_config.xml', e.message
  end
  
  def test_error_is_raised_on_an_illegal_method_in_config
    assert_raises(Templette::TempletteError) { Templette::Page.new('test_data/illegal_method.yml') }
  end
  
  def test_find_all_pages
     pages = Templette::Page.find_all
     assert_equal 2, pages.length
     assert_equal 'Home', pages.first.title.text
  end       
  
  def test_find_all_pages_handles_recursive_directories
    pages = Templette::Page.find_all
    assert page = pages.detect {|p| p.name == 'subdir/index'}
    assert_equal 'Subdir Home', page.title.text
  end
  
  def test_incomplete_yaml
    set_pages_dir 'test_data/'
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
    page = Templette::Page.new(Templette::Page.pages_dir + '/index.yml')
    assert_equal 'Home', page.title.text
    assert_equal 'Home', page.title.text
    assert_equal '/images/whatever.jpg', page.inline.title.image
  end
  
  def test_generate_page
    FileUtils.mkdir('out') unless File.exists?('out')
    output_file = 'out/index.html'
    template = Templette::Template.new('main')
    page = Templette::Page.new(Templette::Page.pages_dir + '/index.yml')
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
  
  
  def test_rendering_with_haml_template
    FileUtils.mkdir('out') unless File.exists?('out')
    set_pages_dir 'test_data/'
    output_file = 'out/haml_user.html'
    page = Templette::Page.new('test_data/haml_user.yml')
    page.generate('out')
    assert File.exists?(output_file), 'output file was not generated'
    file_content = File.open(output_file) {|f| f.read}
    assert_match '<html>', file_content
    assert_match '</html>', file_content
    assert_match '<title>', file_content
    assert_match '</title>', file_content   
    assert_match 'This is the content.', file_content
  ensure
    File.delete(output_file) if File.exists?(output_file)  
  end
  
  def test_rendering_with_haml_partial
    FileUtils.mkdir('out') unless File.exists?('out')
    set_pages_dir 'test_data/'
    output_file = 'out/template_with_render.html'
    page = Templette::Page.new('test_data/template_with_render.yml')
    page.generate('out')
    assert File.exists?(output_file), 'output file was not generated'
    file_content = File.open(output_file) {|f| f.read}
    assert_match '<p>I am some haml!</p>', file_content
  ensure
    File.delete(output_file) if File.exists?(output_file)
  end
  
  def test_render_without_pages_subdir_works
    FileUtils.mkdir('out') unless File.exists?('out')
    set_pages_dir 'test_data/'
    output_file = 'out/template_with_render.html'
    YAML.expects(:load_file).with('test_data/template_with_render.yml').returns(
    {
      'template_name' => 'hammy',
      'sections' => {
        'title' => { 'text' => 'Home' },
        'main' =>  { 'content' => 'render hammy.html.haml' }
       }
     }
    )
    page = Templette::Page.new('test_data/template_with_render.yml')
    page.generate('out')
    assert File.exists?(output_file), 'output file was not generated'
    assert_match '<p>I am some haml!</p>', File.read(output_file)
  ensure
    File.delete(output_file) if File.exists?(output_file)  
  end
  
  def test_render_on_something_named_pages_works
    FileUtils.mkdir('out') unless File.exists?('out')
    set_pages_dir 'test_data/'
    output_file = 'out/template_with_render.html'
    YAML.expects(:load_file).with('test_data/template_with_render.yml').returns(
    {
      'template_name' => 'hammy',
      'sections' => {
        'title' => { 'text' => 'Home' },
        'main' =>  { 'content' => 'render pages.html.haml' }
       }
     }
    )
    page = Templette::Page.new('test_data/template_with_render.yml')
    page.generate('out')
    assert File.exists?(output_file), 'output file was not generated'
    assert_match '<p>I am some haml!</p>', File.read(output_file)
  ensure
    File.delete(output_file) if File.exists?(output_file)  
  end
  
  def test_rendering_with_methods_in_rendered_partials
    FileUtils.mkdir('out') unless File.exists?('out')
    set_pages_dir 'test_data/'
    output_file = 'out/template_with_render.html'
    page = Templette::Page.new('test_data/template_with_render.yml')
    page.generate('out')
    assert File.exists?(output_file), 'output file was not generated'
    file_content = File.open(output_file) {|f| f.read}
    assert_match "<img src='/images/test.jpg'", file_content
    assert_match 'generated by default helper method', file_content
  ensure
    File.delete(output_file) if File.exists?(output_file)
  end
  
  def test_generate_page_with_helper_method
    expected_content = 'generated by helper method'
    FileUtils.mkdir('out') unless File.exists?('out')
    output_file = 'out/dynamic_template.html'
    set_pages_dir 'test_data/'
    page = Templette::Page.new('test_data/dynamic_template.yml')
    page.generate('out')
    assert File.exists?(output_file), 'output file was not generated'
    #should contain content from generated from method calls
    file_content = File.open(output_file) {|f| f.read}
    assert_match expected_content, file_content
  ensure
    File.delete(output_file) if File.exists?(output_file)
  end
  
  def test_generate_page_with_default_helper_method
    expected_content = 'generated by default helper method'
    FileUtils.mkdir('out') unless File.exists?('out')
    output_file = 'out/application_template.html'
    set_pages_dir 'test_data/'
    page = Templette::Page.new('test_data/application_template.yml')
    page.generate('out')
    assert File.exists?(output_file), 'output file was not generated'
    #should contain content from generated from method calls
    file_content = File.open(output_file) {|f| f.read}
    assert_match expected_content, file_content
  ensure
    File.delete(output_file) if File.exists?(output_file)
  end
  
  def test_pages_dir_default
    assert_equal 'pages/', Templette::Page.pages_dir
  end
  
  def test_pages_dir_setter
    assert_equal 'pages/', Templette::Page.pages_dir
    Templette::Page.pages_dir= 'test_data'
    assert_equal 'test_data', Templette::Page.pages_dir
  end

end
