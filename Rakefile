# encoding: utf-8

require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

task default: 'spec:all'

namespace :spec do
  mappers = %w(
    active_record_40
    active_record_41
    active_record_42
  )

  mappers.each do |gemfile|
    desc "Run Tests against #{gemfile}"
    task gemfile do
      sh "BUNDLE_GEMFILE='gemfiles/#{gemfile}.gemfile' bundle install --quiet"
      sh "BUNDLE_GEMFILE='gemfiles/#{gemfile}.gemfile' bundle exec rake -t spec"
    end
  end

  desc 'Run Tests against all ORMs'
  task :all do
    mappers.each do |gemfile|
      sh "BUNDLE_GEMFILE='gemfiles/#{gemfile}.gemfile' bundle install --quiet"
      sh "BUNDLE_GEMFILE='gemfiles/#{gemfile}.gemfile' bundle exec rake spec"
    end
  end
end

desc 'generate rdoc'
task :rdoc do
  sh 'yardoc'
end
