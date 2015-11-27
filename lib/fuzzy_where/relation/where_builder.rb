require 'fuzzy_where/derivation/predicate'
require 'fuzzy_where/derivation/quantifier'
require 'fuzzy_where/predicate_membership_degree'

# SQLf implementation for ActiveRecord
module FuzzyWhere
  module Relation
    # Class to build and {ActiveRecord_Relation} based on fuzzy conditions
    class WhereBuilder
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

      private

      def validate_conditions
        return if @conditions.respond_to?(:key)
        fail ArgumentError,
             "conditions must be a Hash, got #{@_fuzzy_conditions.inspect}"
      end

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
    end
  end
end
