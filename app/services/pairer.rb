class Pairer
  attr_reader :round

  def initialize(round)
    @round = round
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
      player1: player_from_pairing(pairing[0]),
      player2: player_from_pairing(pairing[1])
    }
  end

  def player_from_pairing(player)
    player == Swissper::Bye ? nil : player
  end
end
