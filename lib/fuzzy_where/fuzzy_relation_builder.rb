require 'fuzzy_where/fuzzy_derivation'
require 'fuzzy_where/predicate_membership_degree'

# SQLf implementation for ActiveRecord
module FuzzyWhere
  # Class to build and {ActiveRecord_Relation} based on fuzzy conditions
  class FuzzyRelationBuilder
    class << self
      # Is sqlite3 validation
      def sqlite3?
        active_record_adapter == 'sqlite3'.freeze
      end

      private

      # ActiveRecord adapter
      def active_record_adapter
        ActiveRecord::Base.connection.instance_values['config'][:adapter]
      end
    end
    # @!attribute [r] relation
    #   @return [ActiveRecord_Relation] the current standard query
    attr_reader :relation

    # New FuzzyRelationBuilder intance
    # @param table [String] table name
    # @param relation [ActiveRecord_Relation] query to append
    # @param conditions [Hash] fuzzy conditions
    def initialize(table, relation, conditions)
      @table = table
      @conditions = conditions
      @relation = relation
      @calibration = calibration
      @membership_degrees = []
    end

    # Build an ActiveRecord relation based on fuzzy conditions
    #
    # @return [ActiveRecord_Relation] the final standard query
    def build
      process_conditions
      add_membership_column
      add_calibration_column
      order_by_membership_degree
    end

    private

    def calibration
      @calibration = @conditions.delete(FuzzyWhere.config.calibration_name)
      @calibration ||= 0.5
      validate_calibration
    end

    def validate_calibration
      Float @calibration
    rescue
      raise ArgumentError,
            "calibration must be a Float, got #{@calibration.inspect}"
    end

    def process_conditions
      @conditions.each do |column, predicate|
        pred_def = load_fuzzy_predicate_definition(predicate)
        @relation = derivate_condition(column, pred_def)
        membership_degree_function(column, pred_def)
      end
      @relation
    end

    def load_fuzzy_predicate_definition(predicate)
      pred_def = FuzzyWhere.config.fuzzy_predicate(predicate)
      raise FuzzyError, "couldn't find fuzzy definition" unless pred_def
      pred_def
    end

    def derivate_condition(column, pred_def)
      FuzzyDerivation.new(@relation, @table, column, pred_def)
                     .derivative_condition
    end

    def membership_degree_function(column, pred_def)
      membership_degree = PredicateMembershipDegree.new(@table,
                                                        column,
                                                        pred_def)
      @membership_degrees << membership_degree.membership_function
    end

    def add_membership_column
      name = FuzzyWhere.config.membership_degree_column_name
      @relation = @relation
                  .select("#{@table}.*, (#{membership_degree}) AS #{name}")
    end

    def add_calibration_column
      @relation = @relation.where("(#{membership_degree}) >= ?", @calibration)
    end

    def membership_degree
      if @membership_degrees.size > 1
        min_membership_degree
      else
        @membership_degrees.first
      end
    end

    # Use apropiate SQL method for minimun value
    def min_membership_degree
      if FuzzyRelationBuilder.sqlite3?
        "MIN(#{@membership_degrees.join(',')})"
      else
        "LEAST(#{@membership_degrees.join(',')})"
      end
    end

    def order_by_membership_degree
      name = FuzzyWhere.config.membership_degree_column_name
      @relation.order("#{name} DESC")
    end
  end
end
