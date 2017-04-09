class CreatePairings < ActiveRecord::Migration[5.0]
  def change
    create_table :pairings do |t|
      t.references :round, foreign_key: true
    end
  end
end
