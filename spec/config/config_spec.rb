require 'spec_helper'

describe FuzzyRecord::Configuration do
  subject (:config) { FuzzyRecord.config }

  describe 'where_method_name' do
    context 'by default' do
      it 'should be fuzzy_where' do
        expect(config.where_method_name).to eq :fuzzy_where
      end
    end
    context 'configured via config block' do
      before do
        FuzzyRecord.configure { |c| c.where_method_name = :test }
      end
      it 'should be test' do
        expect(config.where_method_name).to eq :test
      end
      after do
        FuzzyRecord.configure { |c| c.where_method_name = :fuzzy_where }
      end
    end
  end

  describe 'predicates_file' do
    context 'by default' do
      it 'should be nil' do
        expect(config.predicates_file).to eq nil
      end
    end
    context 'configured via config block' do
      before do
        FuzzyRecord.configure { |c| c.predicates_file = '../some/path' }
      end
      it "should be '../some/path'" do
        expect(config.predicates_file).to eq '../some/path'
      end
      after do
        FuzzyRecord.configure { |c| c.predicates_file = nil }
      end
    end
  end

  describe 'fuzzy_predicate' do
    context 'by default' do
      it 'should raise FuzzyRecord::ConfigError' do
        expect { config.fuzzy_predicate(:some_key) }.to raise_error(FuzzyRecord::ConfigError)
      end
    end
    context 'with predicates_file' do
      let(:path) { FIXTURES_PATH.join('fuzzy_predicates.yml') }
      before do
        FuzzyRecord.configure { |c| c.predicates_file = path }
      end
      it 'should fetch young definition' do
        expect(config.fuzzy_predicate(:young)).to eq({"min" => 10, "core1" => 15, "core2" => 20, "max" => 25})
      end
    end
  end
end
