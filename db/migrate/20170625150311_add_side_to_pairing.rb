class AddSideToPairing < ActiveRecord::Migration[5.0]
  def change
    add_column :pairings, :side, :integer
  end
end
