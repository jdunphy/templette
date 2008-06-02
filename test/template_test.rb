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
  
  def test_should_generate_hash_for_yaml_template
    t = Templette::Template.new('main')
    data = YAML::load(t.to_yaml)
    index_yaml = YAML::load_file(GEM_ROOT + '/pages/index.yml')
    assert_generated_hash_has_keys(index_yaml['sections'], data)
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
