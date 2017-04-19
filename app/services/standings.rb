class Standings
  include Enumerable

  attr_reader :tournament

  delegate :each, to: :players

  def initialize(tournament)
    @tournament = tournament
  end

  def players
    @players ||= tournament.players.map{ |p| Standing.new(p) }.sort
  end
end
