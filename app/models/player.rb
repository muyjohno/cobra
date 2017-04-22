class Player < ApplicationRecord
  include Pairable

  belongs_to :tournament

  before_destroy :destroy_pairings

  def pairings
    Pairing.for_player(self)
  end

  def non_bye_pairings
    pairings.non_bye
  end

  def opponents
    pairings.map { |p| p.opponent_for(self) }
  end

  def non_bye_opponents
    non_bye_pairings.map { |p| p.opponent_for(self) }
  end

  def points
    @points ||= pairings.reported.sum{ |pairing| pairing.score_for(self) }
  end

  def sos_earned
    @sos_earned ||= non_bye_pairings.reported.sum { |pairing| pairing.score_for(self) }
  end

  private

  def destroy_pairings
    pairings.destroy_all
  end
end
