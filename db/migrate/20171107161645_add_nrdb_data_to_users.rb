class AddNrdbDataToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :nrdb_id, :integer
    add_column :users, :nrdb_username, :string

    add_index :users, :nrdb_id
  end
end
