class SideDeterminer
  def self.determine_sides(player1, player2, stage)
    return nil unless player_has_pairings(player1, stage) || player_has_pairings(player2, stage)

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

  def self.player_has_pairings(player, stage)
    player.pairings.reported.for_stage(stage).any?
  end
end
