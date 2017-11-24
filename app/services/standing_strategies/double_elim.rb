module StandingStrategies
  class DoubleElim < Base
    def calculate!
      bracket.new(tournament).standings
    end

    private

    def bracket
      Bracket::Factory.bracket_for tournament.players.count
    end
  end
end
