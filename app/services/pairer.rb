class Pairer
  attr_reader :round

  def initialize(round)
    @round = round
    @table_number = 0
  end

  def pair!
    Swissper.pair(
      players.to_a,
      delta_key: :points,
      exclude_key: :unpairable_opponents
    ).each do |pairing|
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
      player2: player_from_pairing(pairing[1]),
      score1: auto_score(pairing, 0),
      score2: auto_score(pairing, 1)
    }
  end

  def player_from_pairing(player)
    player == Swissper::Bye ? nil : player
  end

  def next_table_number
    @table_number += 1
  end

  def auto_score(pairing, player_index)
    return unless pairing[0] == Swissper::Bye || pairing[1] == Swissper::Bye

    pairing[player_index] == Swissper::Bye ? 0 : 6
  end
end
