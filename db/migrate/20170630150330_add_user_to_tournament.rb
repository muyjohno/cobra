class AddUserToTournament < ActiveRecord::Migration[5.0]
  def change
    add_reference :tournaments, :user, foreign_key: true
  end
end
