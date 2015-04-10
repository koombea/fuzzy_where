module FuzzyRecord
  class Railtie < ::Rails::Railtie #:nodoc:
    initializer 'fuzzy_record' do |_app|
      ::ActiveRecord::Base.send :include, FuzzyRecord::ActiveRecordModelExtension
      #ActiveRecord::Base.extend(FuzzyRecord::ActiveRecordModelExtension)
    end
  end
end
