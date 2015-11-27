module FuzzyWhere
  module Relation
    module Quantifiers
      def respond_to?(name, include_private = false)
        if self == ::ActiveRecord::Base
          super
        else
          match = Method.match(self, name)
          match || super
        end
      end

      private

      def method_missing(name, *arguments, &block)
        match = Method.match(self, name)
        if match
          puts "something"
        else
          super
        end
      end

      class Method
        class << self
          def match(model, name)
            FuzzyWhere.config.fuzzy_quantifier(name) if FuzzyWhere.config.quantifiers_file
          end
        end

        attr_reader :model, :name

        def initialize(model, name)
          @model           = model
          @name            = name.to_s
        end

        def define
          model.class_eval <<-CODE, __FILE__, __LINE__ + 1
            def self.#{name}(#{signature})
              #{body}
            end
          CODE
        end
      end
    end
  end
end
