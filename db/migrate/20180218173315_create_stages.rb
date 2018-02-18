class CreateStages < ActiveRecord::Migration[5.0]
  def change
    create_table :stages do |t|
      t.references :tournament, foreign_key: true
      t.integer :number, default: 1
      t.integer :format, null: false, default: 0
    end
  end
end
