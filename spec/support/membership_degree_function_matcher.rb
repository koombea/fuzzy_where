require 'rspec/expectations'

# Comparators and formula helpers for membership degree
module MembershipComparator
  def greater_than(x, equal = false)
    comparator = equal ? '>='.freeze : '>'.freeze
    comparator_condition(x, comparator)
  end

  def less_than(x, equal = false)
    comparator = equal ? '<='.freeze : '<'.freeze
    comparator_condition(x, comparator)
  end

  def comparator_condition(x, comparator)
    "#{@table}.#{@column} #{comparator} #{@predicate[x].to_f}"
  end

  def right_border_formula
    "#{@predicate[:max].to_f} - #{@table}.#{@column})/"\
    "(#{@predicate[:max].to_f} - #{@predicate[:core2].to_f}"
  end

  def left_border_formula
    "#{@table}.#{@column} - #{@predicate[:min].to_f})/"\
    "(#{@predicate[:core1].to_f} - #{@predicate[:min].to_f}"
  end
end

RSpec::Matchers.define :be_decreacing_function do |table, column, predicate|
  include MembershipComparator
  match do |result|
    @table = table
    @column = column
    @predicate = predicate
    result == decreasing
  end

  failure_message do |actual|
    "expected that #{actual} would be eq to #{decreasing}"
  end

  def decreasing
    "CASE WHEN #{less_than(:core2, true)} THEN 1.0 "\
    "WHEN #{greater_than(:core2)} AND #{less_than(:max)} THEN "\
    "(#{right_border_formula}) "\
    'ELSE 0 END'
  end
end

RSpec::Matchers.define :be_increacing_function do |table, column, predicate|
  include MembershipComparator
  match do |result|
    @table = table
    @column = column
    @predicate = predicate
    puts "predicate=#{predicate}"
    result == increasing
  end

  failure_message do |actual|
    "expected that #{actual} would be eq to #{increasing}"
  end

  def increasing
    "CASE WHEN #{greater_than(:core1, true)} THEN 1.0 "\
    "WHEN #{greater_than(:min)} AND #{less_than(:core1)} THEN "\
    "(#{left_border_formula}) "\
    'ELSE 0 END'
  end
end

RSpec::Matchers.define :be_unimodal_function do |table, column, predicate|
  include MembershipComparator
  match do |result|
    @table = table
    @column = column
    @predicate = predicate
    puts "predicate=#{predicate}"
    result == unimodal
  end

  failure_message do |actual|
    "expected that #{actual} would be eq to #{unimodal}"
  end

  def unimodal
    'CASE WHEN '\
    "#{greater_than(:core1, true)} AND #{less_than(:core2, true)} THEN 1.0 "\
    "WHEN #{greater_than(:min)} AND #{less_than(:core1)} THEN "\
    "(#{left_border_formula})"\
    "WHEN #{greater_than(:core2)} AND #{less_than(:max)} THEN "\
    "(#{right_border_formula}) "\
    'ELSE 0 END'
  end
end
