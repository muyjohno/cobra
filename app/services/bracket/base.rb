module Bracket
  class Base
    include Engine

    attr_reader :tournament

    def initialize(tournament)
      @tournament = tournament
    end

    def pair(number)
      games_for_round(number).map do |g|
        {
          table_number: g[:number],
          player1: g[:player1].call(self),
          player2: g[:player2].call(self)
        }
      end
    end

    def seed(number)
      tournament.players.find { |p| p.seed == number }
    end

    def winner(number)
      tournament.rounds
        .map(&:pairings).flatten
        .find{ |i| i.table_number == number }
        .winner
    end

    def loser(number)
      tournament.rounds
        .map(&:pairings).flatten
        .find{ |i| i.table_number == number }
        .loser
    end
  end
end
