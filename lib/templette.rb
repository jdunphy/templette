%w{generator page template errors}.each do |file|
  require File.dirname(__FILE__) +"/templette/#{file}"
end
Dir['./helpers/*.rb'].each do |file|
  #require 'helpers/' + File.basename(file)
  require file.gsub(/.rb$/, '')
end
