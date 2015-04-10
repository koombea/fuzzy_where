module FuzzyRecord
  # Class to take a column and a fuzzy predicate and return de equivalent
  # standard query
  class FuzzyDerivation

    # @!attribute [r] query
    #   @return [ActiveRecord_Relation] the current standard query    
    attr_reader :query

    # New FuzzyDerivation intance
    # @param query [ActiveRecord_Relation] query tu append
    # @param column [String] column name
    # @param fuzzy_predicate [Hash] fuzzy predicate
    def initialize(query, column, fuzzy_predicate)
      @query = query
      @column = column
      @fuzzy_predicate = fuzzy_predicate
    end

    # Take instance attributtes and return a derivated query
    # @return [ActiveRecord_Relation] the current standard query
    def derivative_query
      min = @fuzzy_predicate[:min]
      max = @fuzzy_predicate[:max]

      if min && min != "infinite"
        @query= @query.where("#{@column} >= ?", min)
      end
      if max && max != "infinite"
        @query = @query.where("#{@column} <= ?", max)
      end
      @query
    end
  end
end
