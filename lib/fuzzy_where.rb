require 'fuzzy_where/version'

# SQLf implementation for ActiveRecord
module FuzzyWhere
end

# load Rails/Railtie
begin
  require 'rails'
rescue LoadError
  # do nothing
end

$stderr.puts <<-EOC unless defined?(Rails)
warning: no framework detected.

Your Gemfile might not be configured properly.
---- e.g. ----
Rails:
  gem 'fuzzy_where'
EOC

# load FuzzyWhere components
require 'fuzzy_where/config'
require 'fuzzy_where/exceptions'
require 'fuzzy_where/active_record_model_extension'
require 'fuzzy_where/railtie' if defined?(::Rails)
