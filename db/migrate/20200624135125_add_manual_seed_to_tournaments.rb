class AddManualSeedToTournaments < ActiveRecord::Migration[5.2]
  def change
    add_column :tournaments, :manual_seed, :boolean
  end
end
