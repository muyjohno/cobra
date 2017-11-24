class Standings
  include Enumerable

  attr_reader :tournament

  delegate :each, to: :players

  def initialize(tournament)
    @tournament = tournament
  end

  def players
    @players ||= strategy.new(tournament).calculate!
  end

  def top(number)
    players.map(&:player).select(&:active?)[0...number]
  end

  private

  def strategy
    return StandingStrategies::Swiss unless %w(swiss double_elim).include? tournament.stage

    "StandingStrategies::#{tournament.stage.camelize}".constantize
  end
end
