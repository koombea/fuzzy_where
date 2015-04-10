require 'fuzzy_record/fuzzy_derivation'

module FuzzyRecord
  # Methods to extend ActiveRecord
  module ActiveRecordModelExtension
    extend ActiveSupport::Concern

    included do

      # Fuzzy Where
      # @param fuzzy_conditions [Hash]
      eval <<-RUBY
        def self.#{FuzzyRecord.config.where_method_name}(fuzzy_conditions = {})
          unless fuzzy_conditions.respond_to?(:key)
            raise ArgumentError, "fuzzy_conditions must be a Hash, got " + fuzzy_conditions.inspect
          end
          relation = where(nil)
          fuzzy_conditions.each do |column, predicate|
            pred_def = FuzzyRecord.config.fuzzy_predicate(predicate)
            raise FuzzyRecord::FuzzyError, "could not find fuzzy definition" unless pred_def
            relation = FuzzyRecord::FuzzyDerivation.new(relation, column, pred_def).derivative_query
          end
          relation
        end
      RUBY


    end
  end
end
