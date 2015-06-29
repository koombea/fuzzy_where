FuzzyWhere.configure do |config|
  # config.where_method_name = :fuzzy_where
  # config.membership_degree_column_name = :membership_degree
  config.predicates_file = Rails.root.join('config', 'fuzzy_predicates.yml')
end
