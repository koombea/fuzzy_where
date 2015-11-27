# SQLf implementation for ActiveRecord
module FuzzyWhere
  module Generators #:nodoc
    # Generate a new fuzzy predicate
    class PredicateGenerator < ::Rails::Generators::NamedBase
      argument :attributes, type: :array, default: [], banner: '1 4 infinite infinite'

      desc <<DESC
Description:
    Create a new fuzzy predicate.
DESC
      # Add Fuzzy predicate
      def add_fuzzy_predicate
        return if attributes.empty?
        append_to_file 'config/fuzzy_predicates.yml',
                       predicate_content(name, attributes)
      end

      private

      # Content for fuzzy predicate definition
      def predicate_content(name, attributes)
        buffer = <<-CONTENT
#{name}:
  min:   #{attributes[0].name}
  core1: #{attributes[1].name}
  core2: #{attributes[2].name}
  max:   #{attributes[3].name}
CONTENT
        buffer
      end
    end
  end
end
