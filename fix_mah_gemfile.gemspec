# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fix_mah_gemfile/version'

Gem::Specification.new do |spec|
  spec.name          = "fix_mah_gemfile"
  spec.version       = FixMahGemfile::VERSION
  spec.authors       = ["Eddy Kim"]
  spec.email         = ["eddyhkim@gmail.com"]
  spec.description   = %q{command-line script to modify and run bundler for you in one operation}
  spec.summary       = %q{command-line script to modify and run bundler for you in one operation}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
