FuzzyWhere.configure do |config|
  # config.where_method_name = :fuzzy_where
  # config.calibration_name = :calibration
  config.predicates_file  = ::Rails.root.join('config', 'fuzzy_predicates.yml')
  config.quantifiers_file = ::Rails.root.join('config', 'fuzzy_quantifiers.yml')
end
