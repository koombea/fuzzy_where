# models
class Person < ActiveRecord::Base

end

#migrations
class CreateAllTables < ActiveRecord::Migration
  def self.up
    create_table(:gem_defined_models) { |t| t.string :name; t.integer :age }
    create_table(:people) { |t| t.string :name; t.integer :age }
  end
end
ActiveRecord::Migration.verbose = false
CreateAllTables.up
