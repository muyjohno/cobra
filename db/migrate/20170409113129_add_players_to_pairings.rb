class AddPlayersToPairings < ActiveRecord::Migration[5.0]
  def change
    add_reference :pairings, :player1, foreign_key: { to_table: :players }
    add_reference :pairings, :player2, foreign_key: { to_table: :players }
  end
end
