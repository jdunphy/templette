module Templette
  
  # Standard tag helpers to attempt to make life a little easier.
  # Tag methods will not modify full paths (with an http protocol).
  # If a tag is just a local path, it will heed the configurable site_root,
  # and prepend the necessary directories to build the anticipated path.
  
  module Helpers
    
    # Generates an image tag.  Default options {:alt => filename }
    # 
    # Ex. 
    #    image_tag('ball.png', :alt => 'a red ball')
    #    => "<img src='/images/ball.png' alt='a red ball' />"
    
    #    image_tag('http://flickr.com/hilarious-picture.jpg', :alt => 'lol!')
    #    => "<img src='http://flickr.com/hilarious-picture.jpg' alt='lol!' />"
    
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