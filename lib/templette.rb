%w{data_accessors errors generator method_collector page template}.each do |file|
  require File.dirname(__FILE__) +"/templette/#{file}"
end
