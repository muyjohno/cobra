module PairingStrategies
  class Base
    attr_reader :round
    delegate :tournament, to: :round

    def initialize(round)
      @round = round
    end

    def players
      @players ||= tournament.players.active
    end
  end
end
