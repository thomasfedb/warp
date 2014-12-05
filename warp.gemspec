# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'warp/version'

Gem::Specification.new do |spec|
  spec.name          = "warp"
  spec.version       = Warp::VERSION
  spec.authors       = ["Thomas Drake-Brockman"]
  spec.email         = ["thom@sfedb.com"]
  spec.summary       = "Awesome RSpec matchers for testing your Rails applications."
  spec.description   = "Warp provides a selection of inteligent RSpec matchers for your model, controller and feature specifications."
  spec.homepage      = "https://github.com/thomasfedb/warp"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rspec", ">= 2.14.0"
end
