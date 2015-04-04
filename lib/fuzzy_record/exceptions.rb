module FuzzyRecord
  # Standar FuzzyRecord error
  class FuzzyError < StandardError; end
  # Configuration errors
  class ConfigError < FuzzyError; end
end