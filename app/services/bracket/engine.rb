module Bracket
  module Engine
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def game(number, p1, p2, options = {})
        class_eval do
          @games ||= []
          @games << {
            player1: p1,
            player2: p2,
            round: options[:round],
            number: number
          }
        end
      end

      def seed(x)
        lambda { |context| context.seed(x) }
      end

      def winner(x)
        lambda { |context| context.winner(x) }
      end

      def loser(x)
        lambda { |context| context.loser(x) }
      end

      def seed_of(players, pos)
        lambda { |context| context.seed_of(players, pos) }
      end
    end

    def games
      self.class.instance_variable_get(:@games)
    end

    def games_for_round(number)
      games.select{ |g| g[:round] == number }
    end
  end
end
