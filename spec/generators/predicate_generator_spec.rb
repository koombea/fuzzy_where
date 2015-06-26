require 'spec_helper'
require 'generators/fuzzy_where/predicate_generator'

describe FuzzyWhere::Generators::PredicateGenerator, type: :generator do
  destination File.expand_path('../../tmp', __FILE__)
  arguments %w(test 1 2 3 4)

  before(:all) do
    prepare_destination
    predicates = File.expand_path(FIXTURES_PATH.join('fuzzy_predicates.yml'), __FILE__)
    destination = File.join(destination_root, 'config')

    FileUtils.mkdir_p(destination)
    FileUtils.cp predicates, destination
    run_generator
  end

  it "adds fuzzy predicate" do
    assert_file 'config/fuzzy_predicates.yml', /test:/
  end
end
