module FuzzyRecord
  class Railtie < ::Rails::Railtie #:nodoc:
    initializer 'fuzzy_record' do |_app|
      FuzzyRecord::Hooks.init
    end
  end
end
