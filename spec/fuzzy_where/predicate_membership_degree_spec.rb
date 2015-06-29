require 'spec_helper'
require 'support/membership_degree_function_matcher'

describe FuzzyWhere::PredicateMembershipDegree do
  describe '#membership_function' do
    context 'decreasing function' do
      # kid:
      #   min: infinite
      #   core1: infinite
      #   core2: 10
      #   max: 14
      let!(:kid) { { min: 'infinite', core1: 'infinite', core2: 10, max: 14 } }
      it 'should be decreacing function' do
        membership = FuzzyWhere::PredicateMembershipDegree.new('people', 'age', kid)
        expect(membership.membership_function).to be_decreacing_function('people', 'age', kid)
      end
    end
    context 'increasing function' do
      # old:
      #   min: 48
      #   core1: 55
      #   core2: infinite
      #   max: infinite
      let!(:old) { { min: 48, core1: 55, core2: 'infinite', max: 'infinite' } }
      it 'should be increacing function' do
        membership = FuzzyWhere::PredicateMembershipDegree.new('people', 'age', old)
        expect(membership.membership_function).to be_increacing_function('people', 'age', old)
      end
    end
    context 'unimodal function' do
      # young:
      #   min: 12
      #   core1: 15
      #   core2: 20
      #   max: 25
      let(:young) { { min: 12, core1: 15, core2: 20, max: 25 } }
      it 'should be unimodal function' do
        membership = FuzzyWhere::PredicateMembershipDegree.new('people', 'age', young)
        expect(membership.membership_function).to be_unimodal_function('people', 'age', young)
      end
    end
  end
end
