module FuzzyRecord
  # Class to take a column and a fuzzy predicate and return de equivalent
  # standard query
  class BelongingDegree

    # @!attribute [r] query
    #   @return [ActiveRecord_Relation] the current standard query
    attr_reader :calculation

    # New FuzzyDerivation intance
    # @param column [String] column name
    # @param fuzzy_predicate [Hash] fuzzy predicate
    def initialize(column, fuzzy_predicate)
      @column = column
      @fuzzy_predicate = fuzzy_predicate
    end

    # Take instance attributtes and return a derivated query
    # @return [ActiveRecord_Relation] the current standard query
    def determine_calculation
      min = @fuzzy_predicate[:min]
      max = @fuzzy_predicate[:max]

      @calculation = if !min || min == "infinite"
                        "CASE WHEN #{@column} < #{@fuzzy_predicate[:core2].to_f} THEN 1.0
                              WHEN #{@column} >= #{@fuzzy_predicate[:core2].to_f} AND  #{@column} < #{@fuzzy_predicate[:max].to_f} THEN (#{@fuzzy_predicate[:max].to_f}-#{@column})/(#{@fuzzy_predicate[:max].to_f} - #{@fuzzy_predicate[:core2].to_f})
                              ELSE 0
                         END"
                      elsif !max || max == "infinite"
                        "CASE WHEN #{@column} > #{@fuzzy_predicate[:core1].to_f} THEN 1.0
                              WHEN #{@column} > #{@fuzzy_predicate[:min].to_f} AND  #{@column} <= #{@fuzzy_predicate[:core1].to_f} THEN (#{@column} - #{@fuzzy_predicate[:min].to_f})/(#{@fuzzy_predicate[:core1].to_f} - #{@fuzzy_predicate[:min].to_f})
                              ELSE 0
                         END"
                      else
                        "CASE WHEN #{@column} > #{@fuzzy_predicate[:core1].to_f} AND  #{@column} < #{@fuzzy_predicate[:core2].to_f} THEN 1.0
                              WHEN #{@column} > #{@fuzzy_predicate[:min].to_f} AND  #{@column} < #{@fuzzy_predicate[:core1].to_f} THEN (#{@column} - #{@fuzzy_predicate[:min].to_f})/(#{@fuzzy_predicate[:core1].to_f} - #{@fuzzy_predicate[:min].to_f})
                              WHEN #{@column} >= #{@fuzzy_predicate[:core2].to_f} AND  #{@column} < #{@fuzzy_predicate[:max].to_f} THEN (#{@fuzzy_predicate[:max].to_f}-#{@column})/(#{@fuzzy_predicate[:max].to_f} - #{@fuzzy_predicate[:core2].to_f})
                              ELSE 0
                         END"
                      end
      @calculation
    end

    def self.get_select_query(table_name, relation, belonging_degrees)
      degree = if belonging_degrees.size > 1
                 if ActiveRecord::Base.connection.instance_of? ActiveRecord::ConnectionAdapters::Sqlite3Adapter
                   "MIN(#{belonging_degrees.join(',')})"
                 else
                   "LEAST(#{belonging_degrees.join(',')})"
                 end
               else
                 belonging_degrees.join(',')
               end
      relation.select("#{table_name}.*, (#{degree}) AS fuzzy_degree")
    end

  end
end
