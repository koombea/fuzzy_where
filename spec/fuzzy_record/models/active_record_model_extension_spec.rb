require 'spec_helper'

if defined? ActiveRecord
  describe "FuzzyRecord::ActiveRecordModelExtension" do
    subject { Class.new(ActiveRecord::Base) }
    it { should respond_to :fuzzy_where }
    it { should respond_to :fake_gem_defined_method }
  end
end
