module StandingStrategies
  class DoubleElim < Base
    def calculate!
      bracket.new(stage).standings
    end

    private

    def bracket
      Bracket::Factory.bracket_for stage.players.count
    end
  end
end
