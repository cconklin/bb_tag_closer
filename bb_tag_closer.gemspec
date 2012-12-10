# -*- encoding: utf-8 -*-
require File.expand_path('../lib/bb_tag_closer/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Chase Conklin"]
  gem.email         = [""]
  gem.description   = %q{Automatically closes bb tags found in forums}
  gem.summary       = %q{Allows the customization of tags in an initializer file, and can work with multiple attributes of a model, specified in the close_tags_for method.}
  gem.homepage      = ""
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "debugger"
  gem.add_development_dependency 'rails', '>= 3.2'
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "bb_tag_closer"
  gem.require_paths = ["lib"]
  gem.version       = BBTagCloser::VERSION
end
