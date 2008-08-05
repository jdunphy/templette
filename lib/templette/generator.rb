require 'fileutils'
module Templette
  class Generator
    def initialize(out_dir = 'out', resources_dir = 'resources')
      @out_dir = out_dir
      @resources_dir = resources_dir
      @errors = []
    end
  
    def run
      FileUtils.mkdir(@out_dir) unless File.exists?(@out_dir)
      pages = Page.find_all
      puts "Generating site in: #{@out_dir}; contains #{pages.size} pages"
      pages.each do |page|
        puts "Generating page #{page.name} using template #{page.template.name}"
        begin
          page.generate(@out_dir)
        rescue Templette::TempletteError => e
          @errors.push(e)
        end
      end

      if File.exists?(@resources_dir)
        puts "Copying resources from #{@resources_dir} to #{@out_dir}"
        FileUtils.cp_r("#{@resources_dir}/.", @out_dir)
      end

      if @errors.empty?
        puts "Site generation complete!"
      else
        puts "SITE GENERATED WITH ERRORS!"
        @errors.each { |e| puts e.message }
      end 
    end
    
    def clean
      FileUtils.rm_rf(@out_dir) if File.exists?(@out_dir)
    end
  end
end
