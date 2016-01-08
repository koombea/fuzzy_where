require 'spec_helper'

if defined? ActiveRecord
  require 'support/active_record/ar_stand_in'
  require 'support/active_record/not_there'
  require 'support/active_record/person_fuzzy'
  require 'support/active_record/hotel_fuzzy'
  describe FuzzyWhere::ActiveRecordModelExtension do
    context 'after extending ActiveRecord::Base' do
      it 'works with #respond_to?' do
        expect(ARStandIn).to respond_to :fuzzy_where
      end

      it "doesn't break #respond_to?" do
        expect { ARStandIn.respond_to?(:abstract_class?) }.to_not raise_error
      end

      it "doesn't break #respond_to? for table-less classes" do
        expect(NotThere.table_exists?).to be_falsey
        expect { NotThere.respond_to? :system }.to_not raise_error
      end

      it "doesn't break #method_missing" do
        expect { ARStandIn.random }.to raise_error(NoMethodError)
        begin
          ARStandIn.random
        rescue NoMethodError => error
          expect(error.message).to match(/undefined method `random'/)
        end
      end

      it "doesn't break #method_missing for table-less classes" do
        expect(NotThere.table_exists?).to be_falsey
        expect { NotThere.random }.to raise_error(NoMethodError)
        begin
          NotThere.random
        rescue NoMethodError => error
          expect(error.message).to match(/undefined method `random'/)
        end
      end
    end

    context 'when finding models based on fuzzy predicates' do
      let(:predicates_path) { FIXTURES_PATH.join('fuzzy_predicates.yml') }
      before do
        FuzzyWhere.configure { |c| c.predicates_file = predicates_path }
      end
      let(:kid) { PersonFuzzy.create(name: 'Jhon Doe', age: 9) }
      let(:not_so_kid) { PersonFuzzy.create(name: 'Jhon Doe', age: 13) }
      let(:teenage) { PersonFuzzy.create(name: 'Jhon Doe', age: 14) }
      let(:young) { PersonFuzzy.create(name: 'Jhon Doe', age: 19) }
      let(:not_so_young) { PersonFuzzy.create(name: 'Jhon Doe', age: 23) }
      let(:adult) { PersonFuzzy.create(name: 'Jhon Doe', age: 30) }
      let(:mayor_adult) { PersonFuzzy.create(name: 'Jhon Doe', age: 49) }
      let(:old) { PersonFuzzy.create(name: 'Jhon Doe', age: 60) }

      let(:kids) { [kid, not_so_kid] }
      let(:youngs) { [not_so_kid, teenage, young, not_so_young] }
      let(:adults) { [not_so_young, adult, mayor_adult] }
      let(:olds) { [mayor_adult, old] }

      it 'searches People with kid age' do
        expect(PersonFuzzy.fuzzy_where(age: :kid, calibration: 0.1)).to match_array kids
      end

      it 'searches People with young age' do
        expect(PersonFuzzy.fuzzy_where(age: :young, calibration: 0.1)).to match_array youngs
      end

      it 'searches People with adult age' do
        expect(PersonFuzzy.fuzzy_where(age: :adult, calibration: 0.1)).to match_array adults
      end

      it 'searches People with old age' do
        expect(PersonFuzzy.fuzzy_where(age: :old, calibration: 0.1)).to match_array olds
      end

      it 'raises ArgumentError on invalid params, string condition' do
        expect { PersonFuzzy.fuzzy_where('age = young') }.to raise_error(ArgumentError)
      end

      it 'raises ArgumentError on invalid params, invalid calibration' do
        expect { PersonFuzzy.fuzzy_where(age: :old, calibration: {}) }.to raise_error(ArgumentError)
      end

      after do
        FuzzyWhere.configure { |c| c.predicates_file = nil }
      end
    end
    context 'calculating membership degree' do
      let(:predicates_path) { FIXTURES_PATH.join('fuzzy_predicates.yml') }
      before do
        FuzzyWhere.configure { |c| c.predicates_file = predicates_path }
      end
      let!(:fuzzy_close) { HotelFuzzy.create(name: 'fuzzy_close', price: 24, distance: 1.5) }
      let!(:fuzzy_cheap) { HotelFuzzy.create(name: 'fuzzy_cheap', price: 22, distance: 2) }
      let!(:fuzzy_close_cheap) { HotelFuzzy.create(name: 'fuzzy_close_cheap', price: 22, distance: 1.5) }

      it 'works with #respond_to?' do
        result = HotelFuzzy.fuzzy_where(distance: :close, calibration: 0.1).first
        expect(result).to eq fuzzy_close
        expect(result).to respond_to :membership_degree
      end
      it 'calculates the membership degree' do
        result = HotelFuzzy.fuzzy_where(distance: :close, calibration: 0.1).first
        expect(result).to eq fuzzy_close
        expect(result.membership_degree).to eq 0.75
      end
      it 'calculates the membership degree' do
        result = HotelFuzzy.fuzzy_where(price: :cheap, calibration: 0.1).first
        expect(result).to eq fuzzy_cheap
        expect(result.membership_degree).to eq 0.6
      end
      it 'calculates the membership degree' do
        results = HotelFuzzy.fuzzy_where(price: :cheap, distance: :close, calibration: 0.1)
        expect(results).to match_array [fuzzy_close, fuzzy_cheap, fuzzy_close_cheap]
        results.each do |r|
          calculations = [((3 - r.distance) / (3 - 1)), ((25 - r.price) / (25 - 20))]
          expect(r.membership_degree).to eq calculations.min
        end
      end
      after do
        FuzzyWhere.configure { |c| c.predicates_file = nil }
      end
    end
  end
end
