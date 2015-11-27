module FuzzyWhere
  module Relation
    module ConditionBuild
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
        return pred_def if pred_def
        fail FuzzyError, "couldn't find fuzzy definition: #{predicate}"
      end

      def derivate_condition(column, pred_def)
        Derivation::Predicate.new(@relation, @table, column, pred_def)
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
        if WhereBuilder.sqlite3?
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
end