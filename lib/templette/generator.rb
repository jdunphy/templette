require 'fileutils'
module Templette
  class Generator
    def initialize(out_dir = 'out')
      @out_dir = out_dir
      @errors = []
    end
  
    def run
      FileUtils.mkdir(@out_dir) unless File.exists?(@out_dir)
      pages = Page.find
      puts "Generating site to: #{@out_dir}; contains #{pages.size} pages"
      pages.each do |page|
        puts "Generating page #{page.name} using template #{page.template.name}"
        begin
          page.generate(@out_dir)
        rescue Templette::TempletteError => e
          @errors.push(e)
        end
      end
      if @errors.empty?
        puts "Site generation complete!"
      else
        puts "SITE GENERATED WITH ERRORS!"
        @errors.each { |e| puts "#{e.message}" }
      end 
    end
  end
end
