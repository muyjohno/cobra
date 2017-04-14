class AddTableNumberToPairings < ActiveRecord::Migration[5.0]
  def change
    add_column :pairings, :table_number, :integer
  end
end
