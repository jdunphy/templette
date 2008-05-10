require 'rake'

Gem::Specification.new do |s|

  s.name = 'templette'
  s.author = "Jacob Dunphy and Steve Holder"
  s.version = '0.2.1'
  s.summary = 'HTML site generation through templates'
  
  s.files = FileList['lib/*.rb', 'bin/*'].to_a
  s.autorequire = %q{generator}
  
  s.description = <<-EOF
          HTML site generation through templates
  EOF
  
  s.executables = ['templette']
  s.default_executable = 'templette'
  
  s.email = 'jacob.dunphy@gmail.com'
  
  s.has_rdoc = false
end
