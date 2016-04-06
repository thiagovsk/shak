# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shak/version'

description = <<EOF
shak is a tool for managing the deployment of multiple applications to a
server, usually a personal one. It allows users without technical
knowledge to maintain their own servers at home or in the cloud. shak is
opininated; it will setup applications based on distribution packages,
and in the most secure way possible.

shak is still alpha software, and should not be used in production.
EOF

Gem::Specification.new do |spec|
  spec.name          = "shak"
  spec.version       = Shak::VERSION
  spec.authors       = ["Antonio Terceiro"]
  spec.email         = ["terceiro@softwarelivre.org"]
  spec.summary       = %q{tool for installing and configuring server applications}
  spec.description   = description
  spec.homepage      = "https://gitlab.com/terceiro/shak"
  spec.license       = "AGPL"

  spec.files         = `git ls-files -z`.split("\0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  # basic dependencies
  spec.add_runtime_dependency 'chef'

  # CLI dependencies
  spec.add_runtime_dependency 'commander'
  spec.add_runtime_dependency 'text-table'

  # web frontend dependencies
  spec.add_runtime_dependency 'bootstrap-sass'
  spec.add_runtime_dependency 'sinatra'
  spec.add_runtime_dependency 'slim'
  spec.add_runtime_dependency 'coffee-script'
  spec.add_runtime_dependency 'redcarpet'
  spec.add_runtime_dependency 'sprockets'

  # web frontend's deployment daemon dependencies
  spec.add_runtime_dependency 'listen'

  # web frontend development/test dependencies
  spec.add_development_dependency "foreman"
  spec.add_development_dependency "rack-test"
end
