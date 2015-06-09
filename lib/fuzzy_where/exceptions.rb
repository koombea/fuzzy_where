module FuzzyWhere
  # Standar FuzzyWhere error
  class FuzzyError < StandardError; end
  # Configuration errors
  class ConfigError < FuzzyError; end
end
