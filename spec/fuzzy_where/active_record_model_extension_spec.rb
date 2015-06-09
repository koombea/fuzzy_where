require 'spec_helper'

if defined? ActiveRecord
  require 'support/active_record/ar_stand_in'
  require 'support/active_record/not_there'
  require 'support/active_record/person_fuzzy'
  require 'support/active_record/hotel_fuzzy'
  describe FuzzyWhere::ActiveRecordModelExtension do
    context "after extending ActiveRecord::Base" do
      it "works with #respond_to?" do
        expect(ARStandIn).to respond_to :fuzzy_where
      end
      it "doesn't break #respond_to?" do
        expect{ ARStandIn.respond_to?(:abstract_class?) }.to_not raise_error
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
    context "when finding models based on fuzzy predicates" do
      let(:path) { FIXTURES_PATH.join('fuzzy_predicates.yml') }
      before do
        FuzzyWhere.configure { |c| c.predicates_file = path }
      end
      let(:kid){PersonFuzzy.create(name: "Jhon Doe", age: 9)}
      let(:not_so_kid){PersonFuzzy.create(name: "Jhon Doe", age: 12)}
      let(:teenage){PersonFuzzy.create(name: "Jhon Doe", age: 14)}
      let(:young){PersonFuzzy.create(name: "Jhon Doe", age: 19)}
      let(:not_so_young){PersonFuzzy.create(name: "Jhon Doe", age: 23)}
      let(:adult){PersonFuzzy.create(name: "Jhon Doe", age: 30)}
      let(:mayor_adult){PersonFuzzy.create(name: "Jhon Doe", age: 49)}
      let(:old){PersonFuzzy.create(name: "Jhon Doe", age: 60)}

      let(:kids) {[kid, not_so_kid]}
      let(:youngs) {[not_so_kid, teenage, young, not_so_young]}
      let(:adults) {[not_so_young, adult, mayor_adult]}
      let(:olds) {[mayor_adult, old]}

      it "searchs People with kid age" do
        expect(PersonFuzzy.fuzzy_where(age: :kid)).to match_array kids
      end

      it "searchs People with young age" do
        expect(PersonFuzzy.fuzzy_where(age: :young)).to match_array youngs
      end

      it "searchs People with adult age" do
        expect(PersonFuzzy.fuzzy_where(age: :adult)).to match_array adults
      end

      it "searchs People with old age" do
        expect(PersonFuzzy.fuzzy_where(age: :old)).to match_array olds
      end

      after do
        FuzzyWhere.configure { |c| c.predicates_file = nil }
      end
    end
    context "calculating membership degree" do
      let(:path) { FIXTURES_PATH.join('fuzzy_predicates.yml') }
      before do
        FuzzyWhere.configure { |c| c.predicates_file = path }
      end
      # let(:cheap){HotelFuzzy.create(name:'cheap', price: 10, distance:20)}
      # let(:expensive){HotelFuzzy.create(name:'expensive', price: 26, distance:20)}
      # let(:close){HotelFuzzy.create(name:'close', price: 30, distance:0.5)}
      # let(:close_cheap){HotelFuzzy.create(name:'clse_cheap', price: 30, distance:0.5)}
      let!(:fuzzy_close){ HotelFuzzy.create(name:'fuzzy_close', price: 24, distance:1.5) }
      let!(:fuzzy_cheap){ HotelFuzzy.create(name:'fuzzy_cheap', price: 22, distance:2) }
      let!(:fuzzy_close_cheap){ HotelFuzzy.create(name:'fuzzy_close_cheap', price: 22, distance:1.5) }

      it "works with #respond_to?" do
        result = HotelFuzzy.fuzzy_where(distance: :close).first
        expect(result).to eq fuzzy_close
        expect(result).to respond_to :fuzzy_degree
      end
      it "calculates the membership degree" do
        result = HotelFuzzy.fuzzy_where(distance: :close).first
        expect(result).to eq fuzzy_close
        expect(result.fuzzy_degree).to eq 0.75
      end
      it "calculates the membership degree" do
        result = HotelFuzzy.fuzzy_where(price: :cheap).first
        expect(result).to eq fuzzy_cheap
        expect(result.fuzzy_degree).to eq 0.6
      end
      it "calculates the membership degree" do
        result = HotelFuzzy.fuzzy_where(price: :cheap, distance: :close)
        expect(result).to match_array [fuzzy_close, fuzzy_cheap, fuzzy_close_cheap]
        result.each do |r|
          expect(r.fuzzy_degree).to eq [((3-r.distance)/(3-1)), ((25-r.price)/(25-20))].min

        end
        #expect(result.fuzzy_degree).to eq 0.6
      end
      after do
        FuzzyWhere.configure { |c| c.predicates_file = nil }
      end
    end
  end
end
