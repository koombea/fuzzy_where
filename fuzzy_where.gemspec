# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fuzzy_where/version'

Gem::Specification.new do |spec|
  spec.name          = 'fuzzy_where'
  spec.version       = FuzzyWhere::VERSION
  spec.authors       = ['Gustavo Bazan']
  spec.email         = ['gustavo.bazan@koombea.com']

  spec.summary       = 'SQLf'
  spec.description   = 'SQLf'
  spec.homepage      = 'https://github.com/koombea/fuzzy_where'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '~> 4.0', '>= 4.0.0'
  spec.add_dependency 'actionpack', '~> 4.0', '>= 4.0.0'
  spec.add_dependency 'activerecord', '~> 4.0', '>= 4.0.0'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.2', '>= 3.2.0'
  spec.add_development_dependency 'codeclimate-test-reporter', '~>0.4.7'
  spec.add_development_dependency 'database_cleaner', '~> 1.4.1'
  spec.add_development_dependency 'yard', '~> 0.8.7', '>= 0.8.0'
end
