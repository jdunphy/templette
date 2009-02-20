require File.expand_path(File.dirname(__FILE__) + '/test_helper.rb')

class MethodCollectorTest < Test::Unit::TestCase
  
  context "A MethodCollector" do
    setup do
      @template = Templette::Template.new('test')
      @template.stubs(:path).returns('test.html')
      File.stubs(:exists?).returns(true)
      Templette::MethodCollector.any_instance.stubs(:include_helpers)
    end
    
    should "collect unchained methods" do
      mc = collect_methods("<html><%= foo %> | <%= boo %> </html>")
      assert mc.to_hash.has_key?('foo')
      assert mc.to_hash.has_key?('boo')
    end
    
    should "collect chained methods" do
      mc = collect_methods("<html><%= foo %> | <%= foo.two %> </html>")
      assert mc.to_hash.has_key?('foo')
      assert mc.to_hash['foo'].has_key?('two')
    end
    
    should "return nil when no methods are collected" do
      assert_nil collect_methods("<html></html>").to_hash
    end
  end
  
  private 
  
    def collect_methods(html)
      @template.expects(:to_html).returns(html)
      Templette::MethodCollector.new(@template)
    end
end