module FuzzyRecord
  module Models
    class FuzzyDerivative
      attr_reader :query

      def initialize(query, column, fuzzy_predicate)
        @query = query
        @column = column
        @fuzzy_predicate = fuzzy_predicate
      end

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
end
