class AddPreviousToPlayers < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :previous_id, :integer, index: true
  end
end
