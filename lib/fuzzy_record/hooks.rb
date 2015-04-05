module FuzzyRecord
  class Hooks #:nodoc
    # Load FuzzyRecord methods to ActiveRecord
    def self.init
      ActiveSupport.on_load(:active_record) do
        require 'fuzzy_record/models/active_record_extension'
        ::ActiveRecord::Base.send :include, FuzzyRecord::ActiveRecordExtension
      end
    end
  end
end
