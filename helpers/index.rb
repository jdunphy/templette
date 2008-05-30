module IndexHelper
  def self.init
    @method_called = false
  end
  
  def curr_date
    @@method_called = true
    Time.now
  end
  
  def self.was_method_called?
    @method_called
  end
end