GEM_ROOT = File.expand_path(File.dirname(__FILE__) + "/../")

Dir.glob(GEM_ROOT + '/test/*_test.rb').each do |t|
  require t
end
