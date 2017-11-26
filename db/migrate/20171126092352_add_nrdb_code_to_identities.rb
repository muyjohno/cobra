class AddNrdbCodeToIdentities < ActiveRecord::Migration[5.0]
  def change
    add_column :identities, :nrdb_code, :string
  end
end
