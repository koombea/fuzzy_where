require 'fuzzy_where/fuzzy_derivation'
require 'fuzzy_where/membership_degree'

module FuzzyWhere
  # Methods to extend ActiveRecord
  module ActiveRecordModelExtension
    extend ActiveSupport::Concern

    included do

      # Fuzzy Where
      # @param fuzzy_conditions [Hash]
      eval <<-RUBY
        def self.#{FuzzyWhere.config.where_method_name}(fuzzy_conditions = {}, degree=0.5)
          unless fuzzy_conditions.respond_to?(:key)
            raise ArgumentError, "fuzzy_conditions must be a Hash, got " + fuzzy_conditions.inspect
          end
          relation = where(nil)
          membership_degrees = []
          fuzzy_conditions.each do |column, predicate|
            pred_def = FuzzyWhere.config.fuzzy_predicate(predicate)
            raise FuzzyWhere::FuzzyError, "could not find fuzzy definition" unless pred_def
            relation = FuzzyWhere::FuzzyDerivation.new(relation, quoted_table_name, column, pred_def).derivative_query
            membership_degrees <<  FuzzyWhere::MembershipDegree.new(quoted_table_name, column, pred_def).membership_function
          end
          relation = FuzzyWhere::MembershipDegree.get_select_query(quoted_table_name, relation, membership_degrees)
          relation.order('fuzzy_degree DESC')
        end
      RUBY

      #
    end
  end
end
