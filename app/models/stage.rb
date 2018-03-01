class Stage < ApplicationRecord
  belongs_to :tournament
  has_many :rounds, dependent: :destroy
  has_many :registrations, dependent: :destroy
  has_many :players, through: :registrations

  delegate :top, to: :standings

  enum format: {
    swiss: 0,
    double_elim: 1
  }

  def pair_new_round!
    number = (rounds.pluck(:number).max || 0) + 1
    rounds.create(number: number).tap do |round|
      round.pair!
    end
  end

  def standings
    @standings ||= Standings.new(self)
  end

  def eligible_pairings
    rounds.complete.map(&:pairings).flatten
  end

  def seed(number)
    registrations.find_by(seed: number).try(:player)
  end

  def single_sided?
    double_elim?
  end
end
