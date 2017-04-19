class Pairing < ApplicationRecord
  belongs_to :round
  belongs_to :player1, class_name: 'Player', optional: true
  belongs_to :player2, class_name: 'Player', optional: true
  has_one :tournament, through: :round

  def self.for_player(player)
    where(player1: player).or(where(player2: player))
  end

  def players
    [player1, player2]
  end

  def player1
    super || NilPlayer.new
  end

  def player2
    super || NilPlayer.new
  end

  def reported?
    score1.present? || score2.present?
  end

  def score_for(player)
    return unless players.include? player

    player1 == player ? score1 : score2
  end

  def opponent_for(player)
    return unless players.include? player

    player1 == player ? player2 : player1
  end
end
