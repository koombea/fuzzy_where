require 'fuzzy_record/models/fuzzy_derivative'
module FuzzyRecord
  module ActiveRecordModelExtension
    extend ActiveSupport::Concern


    included do
      self.send(:include, FuzzyRecord::ConfigurationMethods)

      def self.fuzzy_where(fuzzy_conditions={})
        unless fuzzy_conditions.is_a?(Hash)
          raise ArgumentError, "options must be a Hash, got #{fuzzy_conditions.inspect}"
        end
        relation = where(nil)
        fuzzy_conditions.each do |column, v|
          pred = FuzzyRecord.config.fuzzy_predicate(v)
          relation = FuzzyDerivative.new(relation, column, pred).derivative_query
        end
        relation
        #where(opts.insert(0, conditions))

      end
      # eval <<-RUBY
      #   def self.#{FuzzyRecord.config.where_method_name}(fuzzy_conditions={})
      #     unless fuzzy_conditions.is_a?(Hash)
      #       raise ArgumentError, "options must be a Hash, got #{fuzzy_conditions.inspect}"
      #     end
      #     fuzzy_conditions.each do |k, v|
      #       #pred = FuzzyRecord.config.fuzzy_pred(v)
      #       puts "k=#{k}, v=#{v}"
      #       #puts "pred=#{pred}"
      #     end
      #
      #     where("1")
      #     #limit(default_per_page).offset(default_per_page * ((num = num.to_i - 1) < 0 ? 0 : num)).extending do
      #
      #   end
      # RUBY

    end
  end
end