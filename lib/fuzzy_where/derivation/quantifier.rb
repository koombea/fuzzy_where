# SQLf implementation for ActiveRecord
module FuzzyWhere
  # Different SQLf derivations
  module Derivation
    # Class to take a fuzzy quantifier and return the equivalent
    # standard query
    module Quantifier
      # @!attribute [r] query
      #   @return [ActiveRecord_Relation] the current standard query
      attr_reader :query

      # New FuzzyDerivation instance
      # @param query [ActiveRecord_Relation] query to append
      # @param table [String] table name
      # @param column [String] column name
      # @param fuzzy_quantifier [Hash] fuzzy quantifier
      def initialize(query, table, column, fuzzy_quantifier)
        @table = table
        @query = query
        @column = column
        @fuzzy_predicate = fuzzy_quantifier
      end

      # Take instance attributes and return a derivated query
      # @return [ActiveRecord_Relation] the current standard query
      def derivative_condition
        @query
      end
    end
  end
end
