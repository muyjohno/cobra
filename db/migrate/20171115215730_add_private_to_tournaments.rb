class AddPrivateToTournaments < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :private, :boolean, default: false
  end
end
