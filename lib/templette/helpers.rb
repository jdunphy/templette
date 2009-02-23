module Templette
  module Helpers
    
    # Generates an image tag.  Default options {:alt => filename }
    # 
    # Ex. 
    #    image_tag('ball.png', :alt => 'a red ball')
    #    => "<img src='/images/ball.png' alt='a red ball' />"
    
    def image_tag(path, options = {})
      options = {:alt => path}.merge(options)
      "<img src='#{tag_path(path, 'images')}' #{params_to_attributes(options)}/>"
    end
    
    # Generates a link to a stylesheet.  Default options {:type => 'text/css'}
    # 
    # Ex. 
    #    stylesheet_tag('print', :media => 'print')
    #    => "<link href='/stylesheets/print.css' media='print' type='text/css' />"
    
    def stylesheet_tag(path, options = {})
      options = {:type => 'text/css'}.merge(options)
      "<link href='#{tag_path(path, 'stylesheets', 'css')}' #{params_to_attributes(options)}/>"
    end
    
    # Genrates a javascript scrip tag.
    #
    # Ex.
    #     script_tag('slider')
    #     => <script src='/javascripts/slider.js' type='text/javascript'></script>
    
    def script_tag(path)
      "<script src='#{tag_path(path, 'javascripts', 'js')}' type='text/javascript'></script>"
    end
  
    private
    
      def tag_path(path, asset_subdir, file_ext = nil)
        if path =~ /http:\/\//
          path
        else
          "#{Templette.config[:site_root]}#{asset_subdir}/#{path}#{ "."+file_ext if file_ext }"
        end
      end
  
      def params_to_attributes(options)
        options.inject('') do |str, h|
          str << "#{h[0]}='#{h[1]}' "
        end
      end    
  end
end