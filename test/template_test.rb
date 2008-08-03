require File.expand_path(File.dirname(__FILE__) + '/test_helper.rb')

class TemplateTest < Test::Unit::TestCase
  
  def test_should_return_template_html
    assert_not_nil Templette::Template.new('main').to_html
  end
  
  def test_should_raise_exception_if_file_not_found
    assert_raises(Templette::TemplateError) { Templette::Template.new('four-oh-four').to_html }
  end
  
  def test_should_have_informative_error_message
    begin
      Templette::Template.new('four-oh-four').to_html
    rescue Exception => e
      assert_equal "TemplateError - four-oh-four: Template rendering failed.  File not found.", e.message
    end
  end
  
  def test_should_generate_hash_for_yaml_template
    t = Templette::Template.new('main')
    data = YAML::load(t.to_yaml)
    index_yaml = YAML::load_file(TEST_ROOT + '/pages/index.yml')
    assert_generated_hash_has_keys(index_yaml['sections'], data['sections'])
  end
  
  def test_to_yaml_should_contain_template_name
    assert_equal 'main', YAML::load(Templette::Template.new('main').to_yaml)['template_name']
  end
  
  def test_generated_yaml_should_not_contain_helper_methods
    data = YAML::load(Templette::Template.new('application_helper').to_yaml)
    assert !data['sections'].keys.include?('application_helper_method')
    data = YAML::load(Templette::Template.new('dynamic').to_yaml)
    assert !data['sections'].keys.include?('footer_blurb')
  end
  
  def test_should_have_helpers
    t = Templette::Template.new('main')
    assert t.helpers.include?('main_helper')
    assert t.helpers.include?('default_helper')
  end
  
  protected
    def assert_generated_hash_has_keys(source, test_data)
      test_data.each_pair do |k, v|
        assert source.keys.include?(k)
        assert_not_nil source[k]
        assert_generated_hash_has_keys(source[k], test_data[k]) unless v.nil?      
      end
    end
end
