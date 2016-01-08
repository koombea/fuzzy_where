require 'spec_helper'

describe FuzzyWhere::Configuration do
  subject(:config) { FuzzyWhere.config }

  describe 'where_method_name' do
    context 'by default' do
      it 'should be fuzzy_where' do
        expect(config.where_method_name).to eq :fuzzy_where
      end
    end
    context 'configured via config block' do
      before do
        FuzzyWhere.configure { |c| c.where_method_name = :test }
      end
      it 'should be test' do
        expect(config.where_method_name).to eq :test
      end
      after do
        FuzzyWhere.configure { |c| c.where_method_name = :fuzzy_where }
      end
    end
  end

  describe 'calibration_name' do
    context 'by default' do
      it 'should be calibration' do
        expect(config.calibration_name).to eq :calibration
      end
    end
    context 'configured via config block' do
      before do
        FuzzyWhere.configure { |c| c.calibration_name = :test }
      end
      it 'should be test' do
        expect(config.calibration_name).to eq :test
      end
      after do
        FuzzyWhere.configure { |c| c.calibration_name = :calibration }
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
        FuzzyWhere.configure { |c| c.predicates_file = '../some/path' }
      end
      it "should be '../some/path'" do
        expect(config.predicates_file).to eq '../some/path'
      end
      after do
        FuzzyWhere.configure { |c| c.predicates_file = nil }
      end
    end
  end

  describe 'fuzzy_predicate' do
    context 'by default' do
      it 'should raise FuzzyWhere::ConfigError' do
        expect { config.fuzzy_predicate(:some_key) }.to raise_error(FuzzyWhere::ConfigError)
      end
    end
    context 'with predicates_file' do
      let(:path) { FIXTURES_PATH.join('fuzzy_predicates.yml') }
      let(:young_definition) { { 'min' => 12, 'core1' => 15, 'core2' => 20, 'max' => 25 } }
      before do
        FuzzyWhere.configure { |c| c.predicates_file = path }
      end
      it 'should fetch young definition' do
        expect(config.fuzzy_predicate(:young)).to eq(young_definition)
      end
      after do
        FuzzyWhere.configure { |c| c.predicates_file = nil }
      end
    end
    context 'with invalid file' do
      before do
        FuzzyWhere.configure { |c| c.predicates_file = '../some/path' }
      end
      it 'should raise FuzzyWhere::ConfigError' do
        expect { config.fuzzy_predicate(:some_key) }.to raise_error(FuzzyWhere::ConfigError)
      end
      after do
        FuzzyWhere.configure { |c| c.predicates_file = nil }
      end
    end
    context 'with directory configuration' do
      let(:path) { FIXTURES_PATH }
      before do
        FuzzyWhere.configure { |c| c.predicates_file = path }
      end
      it 'should raise FuzzyWhere::ConfigError' do
        expect { config.fuzzy_predicate(:some_key) }.to raise_error(FuzzyWhere::ConfigError)
      end
      after do
        FuzzyWhere.configure { |c| c.predicates_file = nil }
      end
    end
  end
end
