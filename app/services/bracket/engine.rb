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

      %w(seed winner loser seed_of winner_if_higher_seed loser_if_lower_seed).each do |method|
        define_method method do |*args|
          args.unshift(method)
          lambda { |context| context.send(*args) }
        end
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
