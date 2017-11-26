class CreateIdentities < ActiveRecord::Migration[5.0]
  def change
    create_table :identities do |t|
      t.string :name
      t.integer :side
      t.string :faction
    end
    add_index :identities, :side
  end
end
