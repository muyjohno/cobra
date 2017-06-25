module PairingStrategies
  class DoubleElim < Base
    def pair!
      bracket.new(tournament).pair(round.number).each do |pairing|
        round.pairings.create(
          player1: pairing[:player1],
          player2: pairing[:player2],
          table_number: pairing[:table_number]
        )
      end
    end

    private

    def bracket
      num_players = tournament.players.count
      raise "bracket size not supported" unless [4,8].include? num_players

      "Bracket::Top#{num_players}".constantize
    end
  end
end
