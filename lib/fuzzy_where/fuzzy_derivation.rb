# SQLf implementation for ActiveRecord
module FuzzyWhere
  # Class to take a column and a fuzzy predicate and return the equivalent
  # standard query
  class FuzzyDerivation
    # @!attribute [r] query
    #   @return [ActiveRecord_Relation] the current standard query
    attr_reader :query

    # New FuzzyDerivation intance
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

    # Take instance attributtes and return a derivated query
    # @return [ActiveRecord_Relation] the current standard query
    def derivative_condition
      min = @fuzzy_predicate[:min]
      max = @fuzzy_predicate[:max]

      increasing_conditions(min) if min && min != 'infinite'.freeze
      decreasing_conditions(max) if max && max != 'infinite'.freeze
      @query
    end

    private

    def increasing_conditions(min)
      @query = @query.where("#{@table}.#{@column} > ?", min)
    end

    def decreasing_conditions(max)
      @query = @query.where("#{@table}.#{@column} < ?", max)
    end
  end
end
