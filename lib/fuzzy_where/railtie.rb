# SQLf implementation for ActiveRecord
module FuzzyWhere
  class Railtie < ::Rails::Railtie #:nodoc:
    initializer 'fuzzy_where' do |_app|
      # Include module on rails load
      ::ActiveRecord::Base.send :include, FuzzyWhere::ActiveRecordModelExtension
    end
  end
end
