class Tournament < ApplicationRecord
  has_many :players, -> { order(:id) }, dependent: :destroy
  has_many :rounds, dependent: :destroy

  def pair_new_round!
    number = (rounds.pluck(:number).max || 0) + 1
    rounds.create(number: number).tap do |round|
      round.pair!
    end
  end

  def standings
    Standings.new(self)
  end
end
