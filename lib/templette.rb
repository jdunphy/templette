%w{generator page template errors}.each do |file|
  require File.dirname(__FILE__) +"/templette/#{file}"
end
