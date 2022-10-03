# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cocoapods-ddplugin/gem_version.rb'

Gem::Specification.new do |spec|
  spec.name          = 'cocoapods-ddplugin'
  spec.version       = CocoapodsDdplugin::VERSION
  spec.authors       = ['hu']
  spec.email         = ['595632239@163.com']
  spec.description   = %q{A short description of cocoapods-ddplugin.}
  spec.summary       = %q{A longer description of cocoapods-ddplugin.}
  spec.homepage      = 'https://github.com/EXAMPLE/cocoapods-ddplugin'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
