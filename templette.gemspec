require 'rake'

Gem::Specification.new do |spec|

        spec.name = 'templette'
        spec.author = "Jacob Dunphy and Steve Holder"
        spec.version = '0.2'
        spec.summary = 'HTML site generation through templates'
        
        spec.files = FileList['lib/*.rb'].to_a
        spec.require_path = 'lib'
        spec.autorequire = 'generator'
        
        spec.description = <<-EOF
                HTML site generation through templates
        EOF
        
        spec.executables = ['templette']
        spec.default_executable = 'templette'
        
        spec.email = 'jacob.dunphy@gmail.com'
        
        spec.has_rdoc = false
        
end
