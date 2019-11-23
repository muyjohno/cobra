class Pairing < ApplicationRecord
  belongs_to :round
  belongs_to :player1, class_name: 'Player', optional: true
  belongs_to :player2, class_name: 'Player', optional: true
  has_one :tournament, through: :round
  has_one :stage, through: :round

  scope :non_bye, -> { where.not(player1_id: nil, player2_id: nil) }
  scope :bye, -> { where('player1_id IS NULL OR player2_id IS NULL') }
  scope :reported, -> { where.not(score1: nil, score2: nil) }
  scope :completed, -> { joins(:round).where('rounds.completed = ?', true) }
  scope :for_stage, ->(stage) { joins(:round).where(rounds: { stage: stage }) }

  before_save :aggregate_scores
  after_update :cache_standings!, if: Proc.new { round.completed? }
  delegate :cache_standings!, to: :stage

  enum side: {
    player1_is_corp: 1,
    player1_is_runner: 2
  }

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

  def winner
    return if score1 == score2

    score1 > score2 ? player1 : player2
  end

  def loser
    return if score1 == score2

    score1 < score2 ? player1 : player2
  end

  def player1_side
    return unless side

    player1_is_corp? ? :corp : :runner
  end

  def player2_side
    return unless side

    player1_is_corp? ? :runner : :corp
  end

  def side_for(player)
    return unless players.include? player

    player1 == player ? player1_side : player2_side
  end

  private

  def aggregate_scores
    return unless (score1_corp.present? && score1_corp > 0) || (score1_runner.present? && score1_runner > 0) ||
      (score2_corp.present? && score2_corp > 0) || (score2_runner.present? && score2_runner > 0)

    self.score1 = (score1_corp || 0) + (score1_runner || 0)
    self.score2 = (score2_corp || 0) + (score2_runner || 0)
  end
end
