require 'yaml'
require 'active_support/core_ext/hash'
require 'active_support/hash_with_indifferent_access'
require 'active_support/configurable'

# SQLf implementation for ActiveRecord
module FuzzyWhere
  # Configures global settings for FuzzyWhere
  #   FuzzyWhere.configure do |config|
  #     config.where_method_name = :fuzzy_where
  #   end
  def self.configure(&_block)
    yield @config ||= FuzzyWhere::Configuration.new
  end

  # Global settings for FuzzyWhere
  def self.config
    @config
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

      path = path.is_a?(Pathname) ? path : Pathname.new(path)

      if !path.exist?
        fail ConfigError, "The configuration file #{@path} was not found."
      elsif !path.file?
        fail ConfigError, "The configuration file #{@path} is not a file."
      elsif !path.readable?
        fail ConfigError, "The configuration file #{@path} is not readable."
      end
      HashWithIndifferentAccess.new(YAML.load_file(path))
    end
  end

  configure do |config|
    config.where_method_name = :fuzzy_where
    config.membership_degree_column_name = :membership_degree
  end
end
