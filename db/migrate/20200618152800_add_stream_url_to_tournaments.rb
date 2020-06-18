class AddStreamUrlToTournaments < ActiveRecord::Migration[5.2]
  def change
    add_column :tournaments, :stream_url, :string
  end
end
