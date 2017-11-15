class Round < ApplicationRecord
  belongs_to :tournament
  has_many :pairings, -> { order(:table_number) }, dependent: :destroy

  default_scope { order(number: :asc) }

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

  def collated_pairings
    return pairings if pairings.count < 5

    pairings
      .in_groups_of((pairings.count/4.0).ceil)
      .transpose
      .flatten
  end
end
