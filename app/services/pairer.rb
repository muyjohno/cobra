class Pairer
  attr_reader :round

  def initialize(round)
    @round = round
    @table_number = 0
  end

  def pair!
    Swissper.pair(players.to_a).each do |pairing|
      round.pairings.create(pairing_params(pairing))
    end
  end

  private

  def players
    round.tournament.players
  end

  def pairing_params(pairing)
    {
      table_number: next_table_number,
      player1: player_from_pairing(pairing[0]),
      player2: player_from_pairing(pairing[1])
    }
  end

  def player_from_pairing(player)
    player == Swissper::Bye ? nil : player
  end

  def next_table_number
    @table_number += 1
  end
end
