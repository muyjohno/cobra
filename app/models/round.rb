class Round < ApplicationRecord
  belongs_to :tournament
  has_many :pairings, dependent: :destroy

  def pair!
    Pairer.new(self).pair!
  end

  def unpaired_players
    @unpaired_players ||= tournament.players - pairings.map(&:players).flatten
  end

  def repair!
    pairings.destroy_all
    pair!
  end
end
