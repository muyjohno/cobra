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
        .try(:winner)
    end

    def loser(number)
      tournament.rounds
        .map(&:pairings).flatten
        .find{ |i| i.table_number == number }
        .try(:loser)
    end

    def seed_of(players, pos)
      players.map do |lam|
        lam.call(self)
      end.tap do |players|
        return nil unless players.all?
      end.sort_by(&:seed)[pos - 1]
    end

    def standings
      self.class::STANDINGS.map do |lam|
        if lam.is_a? Array
          lam.map { |l| l.call(self) }.compact.try(:first)
        else
          lam.call(self)
        end
      end.map { |p| Standing.new(p) }
    end
  end
end
