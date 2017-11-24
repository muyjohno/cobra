class Standing
  attr_reader :player, :points, :sos, :extended_sos

  delegate :name, :corp_identity, :runner_identity, :seed, to: :player

  def initialize(player, values = {})
    @player = player
    @points = values.fetch(:points, 0) || 0
    @sos = values.fetch(:sos, 0) || 0
    @extended_sos = values.fetch(:extended_sos, 0) || 0
  end

  def <=>(other)
    other.tiebreakers <=> tiebreakers
  end

  def tiebreakers
    [points, sos, extended_sos]
  end
end
