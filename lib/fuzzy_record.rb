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
require 'fuzzy_record/models'
require 'fuzzy_record/hooks'
# if not using Railtie, call `FuzzyRecord::Hooks.init` directly
if defined? Rails
  require 'fuzzy_record/railtie'
  require 'fuzzy_record/engine'
end
