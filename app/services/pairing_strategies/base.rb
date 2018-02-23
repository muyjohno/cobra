module PairingStrategies
  class Base
    attr_reader :round
    delegate :stage, to: :round

    def initialize(round)
      @round = round
    end

    def players
      @players ||= stage.players.active
    end
  end
end
