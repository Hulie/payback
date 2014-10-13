# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'payback/version'

Gem::Specification.new do |spec|
  spec.name          = "payback"
  spec.version       = Payback::VERSION
  spec.authors       = ["Gustav"]
  spec.email         = ["gustav@invoke.se"]
  spec.summary       = %q{Retrieve conversions from affiliate networks}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "excon"
  spec.add_dependency "savon"
  spec.add_dependency "mechanize"
  spec.add_dependency "ruby-hmac"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"

  spec.add_development_dependency "vcr"
  spec.add_development_dependency "guard-minitest"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "minitest-reporters"

end
