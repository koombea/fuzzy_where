require 'fuzzy_where/relation/where_builder'

module FuzzyWhere
  module Relation
    module WhereClause
      define_method(FuzzyWhere.config.where_method_name) do |conditions|


        WhereBuilder.new(quoted_table_name,
                         where(nil),
                         conditions).build
      end

      def fuzzy_quantifiers(quantifier, conditions)
        WhereBuilder.new(quoted_table_name,
                         where(nil),
                         conditions).build
      end
    end
  end
end
