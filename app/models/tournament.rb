class Tournament < ApplicationRecord
  has_many :players, -> { order(:id) }, dependent: :destroy
  has_many :rounds, dependent: :destroy
  belongs_to :previous, class_name: Tournament, optional: true
  has_one :next, class_name: Tournament, foreign_key: :previous_id
  belongs_to :user

  enum pairing_sort: {
    random: 0,
    ranked: 1
  }

  enum stage: {
    swiss: 0,
    double_elim: 1
  }

  delegate :top, to: :standings

  def pair_new_round!
    number = (rounds.pluck(:number).max || 0) + 1
    rounds.create(number: number).tap do |round|
      round.pair!
    end
  end

  def cut_to!(stage, number)
    Tournament.create!(
      name: name + " - Top #{number}",
      stage: stage,
      previous: self
    ).tap do |t|
      top(number).each_with_index do |player, i|
        Player.create!(
          name: player.name,
          active: true,
          corp_identity: player.corp_identity,
          runner_identity: player.runner_identity,
          tournament: t,
          seed: i + 1
        )
      end
    end
  end

  def standings
    Standings.new(self)
  end

  def pairing_sorter
    return PairingSorter::Random unless self.class.pairing_sorts.keys.include? pairing_sort

    "PairingSorters::#{pairing_sort.to_s.camelize}".constantize
  end

  def corp_counts
    players.group_by(&:corp_identity).map do |id, players|
      [id, players.count]
    end.sort_by(&:last).reverse
  end

  def runner_counts
    players.group_by(&:runner_identity).map do |id, players|
      [id, players.count]
    end.sort_by(&:last).reverse
  end
end
