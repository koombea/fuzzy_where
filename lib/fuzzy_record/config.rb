require 'yaml'
require 'active_support/core_ext/hash'
require 'active_support/hash_with_indifferent_access'
require 'active_support/configurable'

#require 'rails'

module FuzzyRecord
  # Configures global settings for FuzzyRecord
  #   FuzzyRecord.configure do |config|
  #     config.where_method_name = :fuzzy_where
  #   end
  def self.configure(&block)
    yield @config ||= FuzzyRecord::Configuration.new
  end

  # Global settings for FuzzyRecord
  def self.config
    @config
  end

  # need a Class for 3.0
  class Configuration #:nodoc:
    include ActiveSupport::Configurable

    config_accessor :where_method_name
    config_accessor :predicates_file

    # Return a fuzzy predicate definition
    # @param [Key] key
    # @return [Hash] fuzzy predicate definition
    def fuzzy_predicate(key)
      @fuzzy_predicates ||= load_yml(predicates_file)
      @fuzzy_predicates["#{key}"]
    end

    private
    # Load YAML file
    def load_yml(path)
      raise ConfigError, "The configuration file is not defined." unless path

      path = path.kind_of?(Pathname) ? path : Pathname.new(path)

      if !path.exist?
        raise ConfigError, "The configuration file #{@path} was not found."
      elsif !path.file?
        raise ConfigError, "The configuration file #{@path} is not a file."
      elsif !path.readable?
        raise ConfigError, "The configuration file #{@path} is not readable."
      end
      HashWithIndifferentAccess.new(YAML.load_file(path))
    end
  end


  configure do |config|
    config.where_method_name = :fuzzy_where
    #config.predicates_file = Rails.root.join('config', 'fuzzy_predicates.yml') if defined? Rails
  end
end
