# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'collection_json_rails/version'

Gem::Specification.new do |spec|
  spec.name          = "collection_json_rails"
  spec.version       = CollectionJsonRails::VERSION
  spec.authors       = ["Carles Jove i Buxeda"]
  spec.email         = ["hola@carlus.cat"]
  spec.summary       = %q{A Ruby gem to serialize objects as Collection+JSON.}
  spec.description   = %q{CollectionJsonRails lets you have models' serializers to format JSON responses following the Collection+JSON media type by Mike Amudsen.}
  spec.homepage      = "https://github.com/carlesjove/collection_json_rails"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
end
