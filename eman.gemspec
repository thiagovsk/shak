# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'eman/version'

Gem::Specification.new do |spec|
  spec.name          = "eman"
  spec.version       = Eman::VERSION
  spec.authors       = ["Antonio Terceiro"]
  spec.email         = ["terceiro@softwarelivre.org"]
  spec.summary       = %q{Easy server manager}
  spec.description   = %q{eman is a tool for managing the deployment of multiple applications to server, usually a personal one. It allows users without technical knowledge to maintain their own servers at home or in the cloud. eman is opininated and will setup applications based on distribution packages in the most secure way possible. }
  spec.homepage      = "https://gitlab.com/terceiro/eman"
  spec.license       = "AGPL"

  spec.files         = Dir.glob('**/*')
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end
