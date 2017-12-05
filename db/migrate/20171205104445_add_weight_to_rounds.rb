class AddWeightToRounds < ActiveRecord::Migration[5.0]
  def change
    add_column :rounds, :weight, :decimal, default: 1.0
  end
end
