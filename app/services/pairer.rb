class Pairer
  attr_reader :round
  delegate :tournament, to: :round

  def initialize(round)
    @round = round
  end

  def pair!
    strategy.new(round).pair!
  end

  private

  def strategy
    return PairingStrategies::Swiss unless %w(swiss double_elim).include? tournament.stage

    "PairingStrategies::#{tournament.stage.camelize}".constantize
  end
end
