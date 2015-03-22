# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shak/version'

description = <<EOF
shak is a tool for managing the deployment of multiple applications to
server, usually a personal one. It allows users without technical
knowledge to maintain their own servers at home or in the cloud. shak is
opininated and will setup applications based on distribution packages in
the most secure way possible.
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

  spec.files         = Dir.glob('**/*')
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"

  spec.add_runtime_dependency 'commander'
  spec.add_runtime_dependency 'text-table'
end
