%w{erb yaml fileutils}.each {|lib| require lib}

%w{data_accessors errors generator page template}.each do |file|
  require File.dirname(__FILE__) +"/templette/#{file}"
end
