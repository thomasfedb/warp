# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'better_matchers/version'

Gem::Specification.new do |spec|
  spec.name          = "better_matchers"
  spec.version       = BetterMatchers::VERSION
  spec.authors       = ["Thomas Drake-Brockman"]
  spec.email         = ["thom@sfedb.com"]
  spec.description   = %q{Better Rails matchers for your RSpec specs.}
  spec.summary       = %q{Better Matchers provides matchers for testing your Rails application with RSpec.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rspec", ">= 2.14.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "fuubar"
end
