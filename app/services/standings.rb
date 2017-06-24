class Standings
  include Enumerable

  attr_reader :tournament

  delegate :each, to: :players

  def initialize(tournament)
    @tournament = tournament
  end

  def players
    @players ||= SosCalculator.calculate!(tournament)
  end
end
