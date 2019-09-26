class Stage < ApplicationRecord
  belongs_to :tournament
  has_many :rounds, dependent: :destroy
  has_many :registrations, dependent: :destroy
  has_many :players, through: :registrations
  has_many :standing_rows

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
    Standings.new(self)
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

  def cache_standings!
    standing_rows.destroy_all
    standings.each_with_index do |standing, i|
      standing_rows.create(
        position: i+1,
        player: standing.player,
        points: standing.points,
        sos: standing.sos,
        extended_sos: standing.extended_sos
      )
    end
  end
end
