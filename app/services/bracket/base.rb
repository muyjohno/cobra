module Bracket
  class Base
    include Engine

    attr_reader :stage

    delegate :seed, to: :stage

    def initialize(stage)
      @stage = stage
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

    def winner(number)
        pairing(number).try(:winner)
    end

    def loser(number)
      pairing(number).try(:loser)
    end

    def winner_if_higher_seed(number)
      w = winner(number)
      l = loser(number)

      return nil unless w && l

      w if w.seed_in_stage(stage) < l.seed_in_stage(stage)
    end

    def loser_if_lower_seed(number)
      w = winner(number)
      l = loser(number)

      return nil unless w && l

      l if w.seed_in_stage(stage) < l.seed_in_stage(stage)
    end

    def seed_of(players, pos)
      players.map do |lam|
        lam.call(self)
      end.tap do |players|
        return nil unless players.all?
      end.sort_by do |p|
        p.seed_in_stage(stage)
      end[pos - 1]
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

    private

    def pairing(number)
      stage.rounds
        .map(&:pairings).flatten
        .find{ |i| i.table_number == number }
    end
  end
end
