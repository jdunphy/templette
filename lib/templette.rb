%w{erb yaml fileutils}.each {|lib| require lib}

%w{helpers data_accessors errors generator method_collector page template engineer}.each do |file|
  require File.dirname(__FILE__) + "/templette/#{file}"
end

module Templette
  CONFIG_FILE_PATH = 'config.rb'
  
  @@config = {:site_root => '/' }
  
  def self.config
    @@config
  end
  
  def self.load_config_from_file
    eval File.read(CONFIG_FILE_PATH) if File.exists?(CONFIG_FILE_PATH)
  end
  
end