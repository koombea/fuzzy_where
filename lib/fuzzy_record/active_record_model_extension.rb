require 'fuzzy_record/fuzzy_derivation'
require 'fuzzy_record/membership_degree'

module FuzzyRecord
  # Methods to extend ActiveRecord
  module ActiveRecordModelExtension
    extend ActiveSupport::Concern

    included do

      # Fuzzy Where
      # @param fuzzy_conditions [Hash]
      eval <<-RUBY
        def self.#{FuzzyRecord.config.where_method_name}(fuzzy_conditions = {}, degree=0.5)
          unless fuzzy_conditions.respond_to?(:key)
            raise ArgumentError, "fuzzy_conditions must be a Hash, got " + fuzzy_conditions.inspect
          end
          relation = where(nil)
          membership_degrees = []
          fuzzy_conditions.each do |column, predicate|
            pred_def = FuzzyRecord.config.fuzzy_predicate(predicate)
            raise FuzzyRecord::FuzzyError, "could not find fuzzy definition" unless pred_def
            relation = FuzzyRecord::FuzzyDerivation.new(relation, column, pred_def).derivative_query
            membership_degrees <<  FuzzyRecord::MembershipDegree.new(column, pred_def).determine_calculation
          end
          relation = FuzzyRecord::MembershipDegree.get_select_query(quoted_table_name, relation, membership_degrees)
          relation.order('fuzzy_degree DESC')
        end
      RUBY

      #
    end
  end
end
