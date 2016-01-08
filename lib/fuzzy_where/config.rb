require 'yaml'
require 'active_support/core_ext/hash'
require 'active_support/hash_with_indifferent_access'
require 'active_support/configurable'

# SQLf implementation for ActiveRecord
module FuzzyWhere
  class << self
    # @!attribute [r] config
    #   @return [FuzzyWhere::Configuration] gem configuration
    attr_reader :config

    # Configures global settings for FuzzyWhere
    #   FuzzyWhere.configure do |config|
    #     config.where_method_name = :fuzzy_where
    #   end
    def configure(&_block)
      yield @config ||= FuzzyWhere::Configuration.new
    end
  end

  # {FuzzyWhere} Configuration class
  class Configuration #:nodoc:
    include ActiveSupport::Configurable

    # @!attribute [rw] where_method_name
    #   @return [String] search method name definition
    config_accessor :where_method_name
    # @!attribute [rw] membership_degree_column_name
    #   @return [String] membership degree column name definition
    config_accessor :membership_degree_column_name
    # @!attribute [rw] calibration_name
    #   @return [String] calibration condition name definition
    config_accessor :calibration_name
    # @!attribute [rw] predicates_file
    #   configuration file location
    config_accessor :predicates_file

    # Return a fuzzy predicate definition
    # @param key [Key] predicate name
    # @return [Hash] fuzzy predicate definition
    def fuzzy_predicate(key)
      @fuzzy_predicates = load_yml(predicates_file)
      @fuzzy_predicates["#{key}"]
    end

    private

    # Load YAML file
    # @param path [Object] predicates definition location
    # @return [Hash] fuzzy predicate definitions
    def load_yml(path)
      fail ConfigError, 'The configuration file is not defined.' unless path
      file = path.is_a?(Pathname) ? path : Pathname.new(path)
      if !file.exist?
        fail ConfigError, "The configuration file #{path} was not found."
      elsif !file.file?
        fail ConfigError, "The configuration file #{path} is not a file."
      elsif !file.readable?
        fail ConfigError, "The configuration file #{path} is not readable."
      end
      HashWithIndifferentAccess.new(YAML.load_file(file))
    end
  end

  configure do |config|
    config.where_method_name = :fuzzy_where
    config.membership_degree_column_name = :membership_degree
    config.calibration_name = :calibration
  end
end
