require 'fuzzy_record/version'

# SQLf implementation for ActiveRecord
module FuzzyRecord

end

# load Rails/Railtie
begin
  require 'rails'
rescue LoadError
#do nothing
end

$stderr.puts <<-EOC unless defined?(Rails)
warning: no framework detected.

Your Gemfile might not be configured properly.
---- e.g. ----
Rails:
  gem 'fuzzy_record'
EOC

# load FuzzyRecord components
require 'fuzzy_record/config'
require 'fuzzy_record/exceptions'
require 'fuzzy_record/active_record_model_extension'
require 'fuzzy_record/railtie' if defined?(::Rails)
