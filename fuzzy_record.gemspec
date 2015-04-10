# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fuzzy_record/version'

Gem::Specification.new do |spec|
  spec.name          = 'fuzzy_record'
  spec.version       = FuzzyRecord::VERSION
  spec.authors       = ['Gustavo Bazan']
  spec.email         = ['gustavo.bazan@koombea.com']

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.summary       = 'SQLf'
  spec.description   = 'SQLf'
  spec.homepage      = 'https://github.com/koombea/fuzzy-record'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '~> 4.0', '>= 4.0.0'
  spec.add_dependency 'actionpack', '~> 4.0', '>= 4.0.0'
  spec.add_dependency 'activerecord', '~> 4.0', '>= 4.0.0'

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.2', '>= 3.2.0'
  spec.add_development_dependency 'database_cleaner', '~> 1.4.1'
  spec.add_development_dependency 'yard', '~> 0.8.7', '>= 0.8.0'
end
