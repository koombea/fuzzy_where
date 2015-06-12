module FuzzyWhere
  # Class to determine what is the membership calculation of a given column
  class MembershipDegree

    # @!attribute [r] calculation
    #   @return [String] calculation query to be used for the given column
    attr_reader :calculation

    # Determine the best approach to get a final membership degree for the whole query
    # and return the query with the select statement
    #
    # @param column [String] table name
    # @param column [ActiveRecord_Relation] relation
    # @param column [Array]  array of calculations to be made
    # @return [ActiveRecord_Relation] final standard query
    def self.get_select_query(table_name, relation, membership_degrees)
      degree = if membership_degrees.size > 1
                 if ActiveRecord::Base.connection.instance_values["config"][:adapter] == 'sqlite3'.freeze
                   "MIN(#{membership_degrees.join(',')})"
                 else
                   "LEAST(#{membership_degrees.join(',')})"
                 end
               else
                 membership_degrees.join(',')
               end
      relation.select("#{table_name}.*, (#{degree}) AS fuzzy_degree")
    end

    # New MembershipDegree intance
    # @param table [String] table name
    # @param column [String] column name
    # @param fuzzy_predicate [Hash] fuzzy predicate
    def initialize(table, column, fuzzy_predicate)
      @table = table
      @column = column
      @fuzzy_predicate = fuzzy_predicate
    end

    # Take instance attributtes and return a calculations for them
    # @return [String] the calculation query to be used for the column
    def membership_function
      min = @fuzzy_predicate[:min]
      max = @fuzzy_predicate[:max]

      @calculation = if !min || min == 'infinite'.freeze
                       decreasing
                     elsif !max || max == 'infinite'.freeze
                       increasing
                     else
                       unimodal
                     end
      @calculation
    end

    private

    def decreasing
      "CASE WHEN #{@table}.#{@column} < #{@fuzzy_predicate[:core2].to_f} THEN 1.0
            WHEN #{@table}.#{@column} >= #{@fuzzy_predicate[:core2].to_f} AND #{@table}.#{@column} < #{@fuzzy_predicate[:max].to_f} THEN (#{@fuzzy_predicate[:max].to_f}-#{@table}.#{@column})/(#{@fuzzy_predicate[:max].to_f} - #{@fuzzy_predicate[:core2].to_f})
            ELSE 0
       END"
    end

    def increasing
      "CASE WHEN #{@table}.#{@column} > #{@fuzzy_predicate[:core1].to_f} THEN 1.0
            WHEN #{@table}.#{@column} > #{@fuzzy_predicate[:min].to_f} AND #{@table}.#{@column} <= #{@fuzzy_predicate[:core1].to_f} THEN (#{@table}.#{@column} - #{@fuzzy_predicate[:min].to_f})/(#{@fuzzy_predicate[:core1].to_f} - #{@fuzzy_predicate[:min].to_f})
            ELSE 0
       END"
    end

    def unimodal
     "CASE WHEN #{@table}.#{@column} > #{@fuzzy_predicate[:core1].to_f} AND #{@table}.#{@column} < #{@fuzzy_predicate[:core2].to_f} THEN 1.0
           WHEN #{@table}.#{@column} > #{@fuzzy_predicate[:min].to_f} AND  #{@table}.#{@column} < #{@fuzzy_predicate[:core1].to_f} THEN (#{@table}.#{@column} - #{@fuzzy_predicate[:min].to_f})/(#{@fuzzy_predicate[:core1].to_f} - #{@fuzzy_predicate[:min].to_f})
           WHEN #{@table}.#{@column} >= #{@fuzzy_predicate[:core2].to_f} AND #{@table}.#{@column} < #{@fuzzy_predicate[:max].to_f} THEN (#{@fuzzy_predicate[:max].to_f} - #{@table}.#{@column})/(#{@fuzzy_predicate[:max].to_f} - #{@fuzzy_predicate[:core2].to_f})
           ELSE 0
      END"
    end

  end
end
