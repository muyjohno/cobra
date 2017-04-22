class SosCalculator
  attr_reader :player

  def self.sos(player)
    new(player).sos
  end

  def self.extended_sos(player)
    new(player).extended_sos
  end

  def initialize(player)
    @player = player
  end

  def sos
    return 0 unless opponents.any?

    opponents.sum do |opponent|
      sos_earned_from(opponent)
    end.to_f / opponents.count
  end

  def extended_sos
    return 0 unless opponents.any?

    opponents.sum do |o|
      SosCalculator.sos(o)
    end.to_f / opponents.count
  end

  private

  def opponents
    @opponents ||= player.non_bye_opponents
  end

  def eligible_pairings_for(player)
    player.pairings.reported
  end

  def sos_earned_from(player)
    pairings = eligible_pairings_for(player)
    return 0 unless pairings.any?

    pairings.sum do |pairing|
      pairing.score_for(player)
    end.to_f / pairings.count
  end
end
