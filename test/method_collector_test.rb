require File.expand_path(File.dirname(__FILE__) + '/test_helper.rb')

class MethodCollectorTest < Test::Unit::TestCase
  
  def test_unnested_method_collection
    template = Templette::Template.new('foo')
    template.stubs(:path).returns('foo.html')
    File.stubs(:exists?).returns(true)
    Templette::MethodCollector.any_instance.stubs(:include_helpers)
    template.expects(:to_html).returns("<html><%= foo %> | <%= boo %> </html>")
    mc = Templette::MethodCollector.new(template)
    assert mc.to_hash.has_key?('foo')
    assert mc.to_hash.has_key?('boo')
  end
  
  def test_nested_method_collection
    template = Templette::Template.new('footwo')
    template.stubs(:path).returns('foo.html')
    File.stubs(:exists?).returns(true)
    Templette::MethodCollector.any_instance.stubs(:include_helpers)
    template.expects(:to_html).returns("<html><%= foo %> | <%= foo.two %> </html>")
    mc = Templette::MethodCollector.new(template)
    assert mc.to_hash.has_key?('foo')
    assert mc.to_hash['foo'].has_key?('two')
  end
  
  def test_method_collector_returns_nil_for_no_methods
    template = Templette::Template.new('fooyou')
    template.stubs(:path).returns('foo.html')
    File.stubs(:exists?).returns(true)
    Templette::MethodCollector.any_instance.stubs(:include_helpers)
    template.expects(:to_html).returns("<html></html>")
    assert_nil Templette::MethodCollector.new(template).to_hash
  end
end