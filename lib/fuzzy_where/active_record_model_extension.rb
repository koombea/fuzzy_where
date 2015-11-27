require 'fuzzy_where/relation/where_clause'
require 'fuzzy_where/relation/quantifiers'

# SQLf implementation for ActiveRecord
module FuzzyWhere
  # Methods to extend ActiveRecord
  module ActiveRecordModelExtension
    extend ActiveSupport::Concern

    included do
      extend Relation::WhereClause
      #extend Relation::Quantifiers
    end
  end
end
