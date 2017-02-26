# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'NAME'
  spec.version       = '1.0'
  spec.authors       = ['Royce Remulla']
  spec.email         = ['youremail@yourdomain.com']
  spec.summary       = %(Short summary of your project)
  spec.description   = %(Longer description of your project.)
  spec.homepage      = 'http://domainforproject.com/'
  spec.license       = 'MIT'

  spec.files         = ['lib/NAME.rb']
  spec.executables   = ['bin/main_class']
  spec.test_files    = ['tests/test_NAME.rb']
  spec.require_paths = ['lib']
end
