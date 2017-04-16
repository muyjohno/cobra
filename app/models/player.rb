class Player < ApplicationRecord
  belongs_to :tournament

  before_destroy :destroy_pairings

  def pairings
    Pairing.for_player(self)
  end

  private

  def destroy_pairings
    pairings.destroy_all
  end
end
