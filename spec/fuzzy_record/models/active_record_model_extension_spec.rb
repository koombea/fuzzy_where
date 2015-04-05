require 'spec_helper'

if defined? ActiveRecord
  describe FuzzyRecord::ActiveRecordModelExtension do
    subject { Class.new(ActiveRecord::Base) }
    it { is_expected.to respond_to :fuzzy_where }
    it { is_expected.to respond_to :fake_gem_defined_method }
  end
end
