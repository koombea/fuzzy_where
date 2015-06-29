class ARStandIn < ActiveRecord::Base
  self.abstract_class = true
  include FuzzyWhere::ActiveRecordModelExtension
end
