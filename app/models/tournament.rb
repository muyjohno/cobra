class Tournament < ApplicationRecord
  has_many :players, -> { order(:id) }, dependent: :destroy
  has_many :rounds, dependent: :destroy

  enum pairing_sort: {
    random: 0,
    ranked: 1
  }

  def pair_new_round!
    number = (rounds.pluck(:number).max || 0) + 1
    rounds.create(number: number).tap do |round|
      round.pair!
    end
  end

  def standings
    Standings.new(self)
  end

  def pairing_sorter
    return PairingSorter::Random unless self.class.pairing_sorts.keys.include? pairing_sort

    "PairingSorters::#{pairing_sort.to_s.camelize}".constantize
  end
end
