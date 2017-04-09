class Tournament < ApplicationRecord
  has_many :players
  has_many :rounds
  enum status: [:registering, :waiting, :playing]

  alias_method :start!, :waiting!

  def pair_new_round!
    number = (rounds.pluck(:number).max || 0) + 1
    rounds.create(number: number).tap do |round|
      round.pair!
      playing!
    end
  end
end
