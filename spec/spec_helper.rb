$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(File.dirname(__FILE__))

begin
  require 'rails'
rescue LoadError
  #do nothing
end



require 'bundler/setup'
Bundler.require

require 'database_cleaner'

# Simulate a gem providing a subclass of ActiveRecord::Base before the Railtie is loaded.
require 'fake_gem' if defined? ActiveRecord

if defined? Rails
  require 'fake_app/rails_app'
  require 'rspec/rails'
end

require 'fuzzy_record'

FIXTURES_PATH = Pathname.new(File.expand_path('../fixtures/', __FILE__))
