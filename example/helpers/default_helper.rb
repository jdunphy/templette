module DefaultHelper
  # Any methods added here will be available to all pages in your site

  def current_date
    Time.now.strftime('%m/%d/%Y')
  end

  def current_year
    Time.now.year
  end
  
  def display_file(path)
    "<pre>
#{File.read(path)}
      </pre>"
  end
end