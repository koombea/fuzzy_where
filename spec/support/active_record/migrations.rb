#migrations
class CreateAllTables < ActiveRecord::Migration
  def self.up
    create_table(:people) { |t| t.string :name; t.integer :age }
    create_table(:hotels) { |t| t.string :name; t.float :price; t.float :distance }
  end
end
ActiveRecord::Migration.verbose = false
CreateAllTables.up
