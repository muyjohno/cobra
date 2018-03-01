class Standings
  include Enumerable

  attr_reader :stage

  delegate :each, to: :players

  def initialize(stage)
    @stage = stage
  end

  def players
    @players ||= strategy.new(stage).calculate!
  end

  def top(number)
    players.map(&:player).select(&:active?)[0...number]
  end

  private

  def strategy
    return StandingStrategies::Swiss unless %w(swiss double_elim).include? stage.format

    "StandingStrategies::#{stage.format.camelize}".constantize
  end
end
