require 'fuzzy_where/fuzzy_relation_builder'

# SQLf implementation for ActiveRecord
module FuzzyWhere
  # Methods to extend ActiveRecord
  module ActiveRecordModelExtension
    extend ActiveSupport::Concern

    included do
      class << self
        define_method(FuzzyWhere.config.where_method_name) do |conditions|
          conditions ||= {}
          validate_conditions(conditions)
          FuzzyRelationBuilder.new(quoted_table_name, where(nil), conditions)
            .build
        end

        private

        def validate_conditions(conditions)
          return if conditions.respond_to?(:key)
          fail ArgumentError,
               "conditions must be a Hash, got #{conditions.inspect}"
        end
      end
    end
  end
end
