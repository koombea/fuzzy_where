# SQLf implementation for ActiveRecord
module FuzzyWhere
  # Class to determine the membership degree calculation
  # for a given column and add the select conditions
  class PredicateMembershipDegree
    # @!attribute [r] calculation
    #   @return [String] calculation query to be used for the given column
    attr_reader :calculation

    # New MembershipDegree intance
    # @param table [String] table name
    # @param column [String] column name
    # @param fuzzy_predicate [Hash] fuzzy predicate
    def initialize(table, column, fuzzy_predicate)
      @table = table
      @column = column
      @fuzzy_predicate = fuzzy_predicate
    end

    # Take instance attributes and return a calculations for them
    # Based on fuzzy set trapezium function
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

    # Decreasing function calculation
    # @return [String] condition representation for membership calculation
    def decreasing
      "CASE WHEN #{less_than(:core2, true)} THEN 1.0 "\
      "WHEN #{greater_than(:core2)} AND #{less_than(:max)} THEN "\
      "(#{right_border_formula}) ELSE 0 END"
    end

    # Increasing function calculation
    # @return [String] condition representation for membership calculation
    def increasing
      "CASE WHEN #{greater_than(:core1, true)} THEN 1.0 "\
      "WHEN #{greater_than(:min)} AND #{less_than(:core1)} THEN "\
      "(#{left_border_formula}) ELSE 0 END"
    end

    # Unimodal function calculation
    # @return [String] condition representation for membership calculation
    def unimodal
      'CASE WHEN '\
      "#{greater_than(:core1, true)} AND #{less_than(:core2, true)} THEN 1.0 "\
      "WHEN #{greater_than(:min)} AND #{less_than(:core1)} THEN "\
      "(#{left_border_formula})"\
      "WHEN #{greater_than(:core2)} AND #{less_than(:max)} THEN "\
      "(#{right_border_formula}) ELSE 0 END"
    end

    def greater_than(x, equal = false)
      comparator = equal ? '>='.freeze : '>'.freeze
      comparator_condition(x, comparator)
    end

    def less_than(x, equal = false)
      comparator = equal ? '<='.freeze : '<'.freeze
      comparator_condition(x, comparator)
    end

    def comparator_condition(x, comparator)
      "#{@table}.#{@column} #{comparator} #{@fuzzy_predicate[x].to_f}"
    end

    def right_border_formula
      "#{@fuzzy_predicate[:max].to_f} - #{@table}.#{@column})/"\
      "(#{@fuzzy_predicate[:max].to_f} - #{@fuzzy_predicate[:core2].to_f}"
    end

    def left_border_formula
      "#{@table}.#{@column} - #{@fuzzy_predicate[:min].to_f})/"\
      "(#{@fuzzy_predicate[:core1].to_f} - #{@fuzzy_predicate[:min].to_f}"
    end
  end
end
