class RemoveStatusFromTournaments < ActiveRecord::Migration[5.0]
  def change
    remove_column :tournaments, :status, :integer, default: 0
  end
end
