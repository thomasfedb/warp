# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'warp/version'

Gem::Specification.new do |spec|
  spec.name          = "warp"
  spec.version       = Warp::VERSION
  spec.authors       = ["Thomas Drake-Brockman"]
  spec.email         = ["thom@sfedb.com"]
  spec.description   = %q{Rails matchers for your RSpec specs.}
  spec.summary       = %q{Warp provides matchers for testing your Rails application with RSpec.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rspec", ">= 2.14.0"
end
