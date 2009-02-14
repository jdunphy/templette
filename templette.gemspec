require 'rake'

Gem::Specification.new do |s|

  s.name = 'templette'
  s.author = "Jacob Dunphy and Steve Holder"
  s.version = '0.4.1'
  s.summary = 'HTML site generation through templates'
  
  s.files = FileList['lib/**/*.rb', 'bin/*', 'files/*'].to_a
  
  s.description = <<-EOF
          HTML site generation through templates
  EOF
  
  s.executables = ['templette']
  s.default_executable = 'templette'
  
  s.email = 'jacob.dunphy@gmail.com'
  s.homepage = 'http://github.com/jdunphy/templette'
  s.rubyforge_project = 'templette'
  s.has_rdoc = true
end
