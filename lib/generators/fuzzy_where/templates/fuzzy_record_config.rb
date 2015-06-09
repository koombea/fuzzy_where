FuzzyWhere.configure do |config|
  # config.where_method_name = :fuzzy_where
  config.predicates_file = Rails.root.join('config', 'fuzzy_predicates.yml')
end
