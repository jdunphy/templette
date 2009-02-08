require File.expand_path(File.dirname(__FILE__) + '/test_helper.rb')

class EngineerTest < Test::Unit::TestCase
  
  def test_should_determine_type_from_filenames
    assert_equal 'erb', Templette::Engineer.determine_type("foo.html")
    assert_equal 'erb', Templette::Engineer.determine_type("foo.html.erb")
    assert_equal 'haml', Templette::Engineer.determine_type("foo.html.haml")
  end
  
  def test_should_load_erb_engine
    assert !defined?(Templette::Engines::Erb)
    engine = Templette::Engineer.engine_for('erb')
    assert_equal Templette::Engines::Erb, engine.class
  end
  
  def test_should_load_haml_engine
    assert !defined?(Templette::Engines::Haml)
    engine = Templette::Engineer.engine_for('haml')
    assert_equal Templette::Engines::Haml, engine.class
  end
end