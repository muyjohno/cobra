module StandingStrategies
  class Base
    attr_reader :tournament

    def initialize(tournament)
      @tournament = tournament
    end
  end
end
