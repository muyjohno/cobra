class Pairer
  attr_reader :round
  delegate :stage, to: :round

  def initialize(round)
    @round = round
  end

  def pair!
    strategy.new(round).pair!
  end

  private

  def strategy
    return PairingStrategies::Swiss unless %w(swiss double_elim).include? stage.format

    "PairingStrategies::#{stage.format.camelize}".constantize
  end
end
