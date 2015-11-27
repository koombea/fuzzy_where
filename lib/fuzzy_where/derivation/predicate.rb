# SQLf implementation for ActiveRecord
module FuzzyWhere
  # Different SQLf derivations
  module Derivation
    # Class to take a column and a fuzzy predicate and return the equivalent
    # standard query
    class Predicate
      # @!attribute [r] query
      #   @return [ActiveRecord_Relation] the current standard query
      attr_reader :query

      # New FuzzyDerivation instance
      # @param query [ActiveRecord_Relation] query to append
      # @param table [String] table name
      # @param column [String] column name
      # @param fuzzy_predicate [Hash] fuzzy predicate
      def initialize(query, table, column, fuzzy_predicate)
        @table = table
        @query = query
        @column = column
        @fuzzy_predicate = fuzzy_predicate
      end

      # Take instance attributes and return a derivated query
      # @return [ActiveRecord_Relation] the current standard query
      def derivative_condition
        increasing_conditions_arel(min) if min?
        decreasing_conditions_arel(max) if max?
        @query
      end

      def conditions_string
        conditions = ''
        conditions << increasing_conditions(min) if min?
        conditions << 'AND' << decreasing_conditions(max) if max?
        conditions
      end

      private

      def min
        @min ||= @fuzzy_predicate[:min]
      end

      def max
        @max ||= @fuzzy_predicate[:max]
      end

      def min?
        min && min != 'infinite'.freeze
      end

      def max?
        max && max != 'infinite'.freeze
      end

      def increasing_conditions_arel(min)
        @query = @query.where("#{@table}.#{@column} > ?", min)
      end

      def decreasing_conditions_arel(max)
        @query = @query.where("#{@table}.#{@column} < ?", max)
      end

      def increasing_conditions(min)
        "#{@table}.#{@column} > ?"
      end

      def decreasing_conditions(max)
        "#{@table}.#{@column} < ?"
      end
    end
  end
end
