GEM_ROOT = File.expand_path(File.dirname(__FILE__) + "/../")

Dir.glob(File.dirname(__FILE__) + '/*_test.rb').each do |t|
  require t
end
