require 'support/active_record/ar_stand_in'

class PersonFuzzy < ARStandIn;
  self.table_name = :people
end
