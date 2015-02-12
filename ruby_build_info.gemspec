# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_build_info/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruby_build_info'
  spec.version       = RubyBuildInfo::VERSION
  spec.authors       = ['Adam Georgeson']
  spec.email         = ['adamgeorgeson89@gmail.com']
  spec.summary       = %q{Rack middleware to output build information such as version control, bundled gems, and specified files to a webpage.}
  spec.description   = %q{Rack middleware to output build information such as version control, bundled gems, and specified files to a webpage.}
  spec.homepage      = 'https://github.com/adamgeorgeson/ruby_build_info'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rack'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'pry'
end
