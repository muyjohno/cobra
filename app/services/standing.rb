class Standing
  attr_reader :player

  delegate :name, :points, to: :player

  def initialize(player)
    @player = player
  end

  def <=>(other)
    [other.points, other.sos] <=> [points, sos]
  end

  def sos
    @sos ||= player.non_bye_opponents.sum(&:sos_earned)
  end
end
