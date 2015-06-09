require 'support/active_record/ar_stand_in'

class HotelFuzzy < ARStandIn;
  self.table_name = :hotels
end
