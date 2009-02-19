module Templette
  class Generator
    def initialize(out_dir = 'out', resources_dir = 'resources')
      @out_dir = out_dir
      @resources_dir = resources_dir
      @errors = []
    end
  
    def run
      FileUtils.mkdir_p(output_location) unless File.exists?(output_location)
      pages = Page.find_all
      puts "Generating site in: #{output_location}; contains #{pages.size} pages"
      pages.each do |page|
        puts "Generating page #{page.name} using template #{page.template.name}"
        begin
          page.generate(output_location)
        rescue Templette::TempletteError => e
          @errors.push(e)
        end
      end

      if File.exists?(@resources_dir)
        puts "Copying resources from #{@resources_dir} to #{output_location}"
        FileUtils.cp_r("#{@resources_dir}/.", output_location)
      end

      if @errors.empty?
        puts "Site generation complete!"
      else
        puts "SITE GENERATED WITH ERRORS!"
        @errors.each { |e| puts e.message }
      end 
    end
    
    def output_location
      @out_dir + Templette::config[:site_root]
    end
    
    def clean
      FileUtils.rm_rf(@out_dir) if File.exists?(@out_dir)
    end
  end
end
