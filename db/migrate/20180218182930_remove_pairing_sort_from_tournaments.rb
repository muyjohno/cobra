class RemovePairingSortFromTournaments < ActiveRecord::Migration[5.0]
  def change
    remove_column :tournaments, :pairing_sort, :integer, default: 0
  end
end
