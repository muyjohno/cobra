class SideDeterminer
  def self.determine_sides(player1, player2)
    return nil if player1.pairings.reported.count + player2.pairings.reported.count == 0

    diff1 = differential(player1)
    diff2 = differential(player2)

    return :player1_is_corp if diff1 < diff2
    return :player1_is_runner if diff1 > diff2

    [:player1_is_corp, :player1_is_runner].sample
  end

  private

  # positive for more often corp, negative for more often runner
  def self.differential(player)
    player.pairings.reported.inject(0) do |total, pairing|
      total += 1 if pairing.player1 == player && pairing.player1_is_corp?
      total += 1 if pairing.player2 == player && pairing.player1_is_runner?

      total -= 1 if pairing.player1 == player && pairing.player1_is_runner?
      total -= 1 if pairing.player2 == player && pairing.player1_is_corp?

      total
    end
  end
end
