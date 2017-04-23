class Pairer
  attr_reader :round
  delegate :tournament, to: :round

  def initialize(round)
    @round = round
  end

  def pair!
    Swissper.pair(
      players.to_a,
      delta_key: :points,
      exclude_key: :unpairable_opponents
    ).each do |pairing|
      round.pairings.create(pairing_params(pairing))
    end
    apply_numbers!(tournament.pairing_sorter)
  end

  private

  def players
    tournament.players.active
  end

  def pairing_params(pairing)
    {
      player1: player_from_pairing(pairing[0]),
      player2: player_from_pairing(pairing[1]),
      score1: auto_score(pairing, 0),
      score2: auto_score(pairing, 1)
    }
  end

  def player_from_pairing(player)
    player == Swissper::Bye ? nil : player
  end

  def auto_score(pairing, player_index)
    return unless pairing[0] == Swissper::Bye || pairing[1] == Swissper::Bye

    pairing[player_index] == Swissper::Bye ? 0 : 6
  end

  def apply_numbers!(sorter)
    sorter.sort(round.pairings).each_with_index do |pairing, i|
      pairing.update(table_number: i + 1)
    end
  end
end
