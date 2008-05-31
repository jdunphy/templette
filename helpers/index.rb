module IndexHelper
  def self.init(return_val = Time.now)
    @method_called = false
    @return_val = return_val
  end
  
  def curr_date
    puts 'called!'
    @@method_called = true
    @@return_val
  end
  
  def self.was_method_called?
    @method_called
  end
end