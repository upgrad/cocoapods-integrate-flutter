# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cocoapods-integrate-flutter/gem_version.rb'

Gem::Specification.new do |spec|
  spec.name          = 'cocoapods-integrate-flutter'
  spec.version       = CocoapodsIntegrateFlutter::VERSION
  spec.authors       = ['kerry']
  spec.email         = ['me@prateekgrover.com']
  spec.description   = %q{Uses the podhelper.rb from the flutter repository and adds to the pre_install hook of cocoapods. Integrates the flutter project without polluting the main Podfile.}
  spec.summary       = %q{A plugin to integrate flutter with existing iOS application.}
  spec.homepage      = 'https://github.com/upgrad/cocoapods-integrate-flutter'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
