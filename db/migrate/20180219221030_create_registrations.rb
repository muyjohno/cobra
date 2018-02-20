class CreateRegistrations < ActiveRecord::Migration[5.0]
  def change
    create_table :registrations do |t|
      t.references :player, foreign_key: true
      t.references :stage, foreign_key: true
      t.integer :seed
    end
  end
end
