class Standing
  attr_reader :player

  delegate :name, to: :player

  def initialize(player)
    @player = player
  end

  def <=>(other)
    [other.points, other.sos] <=> [points, sos]
  end

  def points
    @points ||= player.pairings.sum{ |pairing| pairing.score_for(player) }
  end

  def sos
    @sos ||= player.non_bye_opponents.sum(&:sos_earned)
  end
end
