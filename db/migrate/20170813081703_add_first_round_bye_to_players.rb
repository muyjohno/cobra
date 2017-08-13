class AddFirstRoundByeToPlayers < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :first_round_bye, :boolean, default: false
  end
end
