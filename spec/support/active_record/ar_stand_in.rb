class ARStandIn < ActiveRecord::Base
  self.abstract_class = true
end
ARStandIn.extend FuzzyWhere::ActiveRecordModelExtension
