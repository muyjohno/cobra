class AddActiveToPlayers < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :active, :boolean, default: true
  end
end
