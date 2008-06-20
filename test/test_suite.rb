GEM_ROOT = File.expand_path(File.dirname(__FILE__) + "/../")

%w{template page generator error data_accessors}.each do |t|
  require GEM_ROOT + "/test/#{t}_test"
end
