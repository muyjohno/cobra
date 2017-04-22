class AddIdentitiesToPlayers < ActiveRecord::Migration[5.0]
  def change
    add_column :players, :corp_identity, :string
    add_column :players, :runner_identity, :string
  end
end
