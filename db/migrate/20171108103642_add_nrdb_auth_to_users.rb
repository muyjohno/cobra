class AddNrdbAuthToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :nrdb_access_token, :string
    add_column :users, :nrdb_refresh_token, :string
  end
end
