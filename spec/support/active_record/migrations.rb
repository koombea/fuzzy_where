# Migrations
class CreateAllTables < ActiveRecord::Migration
  def self.up
    create_table(:people) do |t|
      t.string :name
      t.integer :age
    end
    create_table(:hotels) do |t|
      t.string :name
      t.float :price
      t.float :distance
    end
  end
end
ActiveRecord::Migration.verbose = false
CreateAllTables.up
