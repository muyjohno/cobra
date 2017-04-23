class AddPairingSortToTournaments < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :pairing_sort, :integer, default: 0
  end
end
