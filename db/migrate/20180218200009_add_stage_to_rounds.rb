class AddStageToRounds < ActiveRecord::Migration[5.0]
  def change
    add_reference :rounds, :stage, foreign_key: true
  end
end
