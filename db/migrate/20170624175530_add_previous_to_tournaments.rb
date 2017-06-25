class AddPreviousToTournaments < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :previous_id, :integer, index: true
  end
end
