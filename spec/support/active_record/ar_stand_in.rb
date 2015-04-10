class ARStandIn < ActiveRecord::Base;
  self.abstract_class = true
  include FuzzyRecord::ActiveRecordModelExtension
end
