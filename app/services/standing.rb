class Standing
  attr_reader :player, :calculator

  delegate :name, :points, to: :player

  def initialize(player)
    @player = player
    @calculator = SosCalculator.new(player)
  end

  def <=>(other)
    other.tiebreakers <=> tiebreakers
  end

  def sos
    @sos ||= calculator.sos
  end

  def extended_sos
    @extended_sos ||= calculator.extended_sos
  end

  def tiebreakers
    [points, sos, extended_sos]
  end
end
