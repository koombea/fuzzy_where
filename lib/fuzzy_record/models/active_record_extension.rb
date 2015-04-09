require 'fuzzy_record/models/active_record_model_extension'

module FuzzyRecord
  module Models
    module ActiveRecordExtension
      extend ActiveSupport::Concern

      module ClassMethods
        # Future subclasses will pick up the models extension
        def inherited(kls) #:nodoc:
          super
          kls.send(:include, FuzzyRecord::Models::ActiveRecordModelExtension) if kls.superclass == ::ActiveRecord::Base
        end
      end

      included do
        # Existing subclasses pick up the models extension as well
        self.descendants.each do |kls|
          kls.send(:include, FuzzyRecord::Models::ActiveRecordModelExtension) if kls.superclass == ::ActiveRecord::Base
        end
      end
    end
  end

end
