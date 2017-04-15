class Round < ApplicationRecord
  belongs_to :tournament
  has_many :pairings

  def pair!
    Pairer.new(self).pair!
  end

  def unpaired_players
    @unpaired_players ||= tournament.players - pairings.map(&:players).flatten
  end
end
