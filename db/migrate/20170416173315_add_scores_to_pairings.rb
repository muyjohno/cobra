class AddScoresToPairings < ActiveRecord::Migration[5.0]
  def change
    add_column :pairings, :score1, :integer
    add_column :pairings, :score2, :integer
    add_column :pairings, :reported, :boolean, default: false
  end
end
