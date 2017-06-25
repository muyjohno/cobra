class AddStageToTournaments < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :stage, :integer, default: 0
  end
end
