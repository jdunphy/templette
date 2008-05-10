require 'template'
require 'page'
require 'fileutils'

class Generator
  def initialize(out_dir = 'out')
    @out_dir = out_dir
  end
  
  def run
    FileUtils.mkdir(@out_dir) unless File.exists?(@out_dir)
    pages = Page.find
    puts "Generating site to: #{@out_dir}; contains #{pages.size} pages"
    pages.each do |page|
      puts "Generating page #{out_file} using template #{template.name}"
      page.generate(@out_dir)
    end
  end
end

