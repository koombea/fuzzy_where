#migrations
class CreateAllTables < ActiveRecord::Migration
  def self.up
    create_table(:people) { |t| t.string :name; t.integer :age }
  end
end
ActiveRecord::Migration.verbose = false
CreateAllTables.up
