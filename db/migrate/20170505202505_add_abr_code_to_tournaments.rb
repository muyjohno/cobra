class AddAbrCodeToTournaments < ActiveRecord::Migration[5.0]
  def change
    add_column :tournaments, :abr_code, :string
  end
end
