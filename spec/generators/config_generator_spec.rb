require 'spec_helper'
require 'generators/fuzzy_where/config_generator'

describe FuzzyWhere::Generators::ConfigGenerator, type: :generator do
  destination File.expand_path('../../tmp', __FILE__)

  before(:all) do
    prepare_destination
    run_generator
  end

  it 'copies config filer' do
    assert_file 'config/initializers/fuzzy_where_config.rb'
  end

  it 'copies predicates file' do
    assert_file 'config/fuzzy_predicates.yml'
  end

  it 'copies quantifiers file' do
    assert_file 'config/fuzzy_quantifiers.yml'
  end
end
