class Player < ApplicationRecord
  belongs_to :tournament

  before_destroy :destroy_pairings

  def pairings
    Pairing.for_player(self)
  end

  def opponents
    pairings.map { |p| p.opponent_for(self) }
  end

  def non_bye_opponents
    opponents.select { |o| o.id }
  end

  def sos_earned
    pairings.select do |p|
      p.opponent_for(self).id
    end.sum { |p| p.score_for(self) }
  end

  private

  def destroy_pairings
    pairings.destroy_all
  end
end
