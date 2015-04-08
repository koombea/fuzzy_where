require 'fuzzy_record/models/fuzzy_derivative'

module FuzzyRecord
  module Models
    module ActiveRecordModelExtension
      extend ActiveSupport::Concern

      included do
        self.send(:include, FuzzyRecord::ConfigurationMethods)

        # Fuzzy Where
        eval <<-RUBY
          def self.#{FuzzyRecord.config.where_method_name}(fuzzy_conditions = {})
            unless fuzzy_conditions.respond_to?(:key)
              raise ArgumentError, "fuzzy_conditions must be a Hash, got " + fuzzy_conditions.inspect
            end
            relation = where(nil)
            fuzzy_conditions.each do |column, predicate|
              pred_def = FuzzyRecord.config.fuzzy_predicate(predicate)
              raise FuzzyError, "could not find fuzzy definition" unless pred_def
              relation = FuzzyDerivative.new(relation, column, pred_def).derivative_query
            end
            relation
          end
        RUBY
      end
    end
  end
  
end
