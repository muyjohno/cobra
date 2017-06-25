class AddSeedToPlayers < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :seed, :integer
  end
end
