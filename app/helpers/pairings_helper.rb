module PairingsHelper
  def pairing_player_select(form, label, round)
    form.input label,
      collection: round.unpaired_players,
      include_blank: '(Bye)',
      label: false,
      wrapper: false,
      input_html: { class: 'form-control mx-2' }
  end

  def preset_score_button(score1, score2, pairing)
    link_to "#{score1}-#{score2}",
      report_tournament_round_pairing_path(
        pairing.tournament,
        pairing.round,
        pairing,
        pairing: { score1: score1, score2: score2}
      ),
      method: :post,
      class: 'btn btn-primary'
  end

  def side_value(player, side, pairing)
    return unless pairing.players.include? player

    [:player1_is_corp, :player1_is_runner].tap do |options|
      options.reverse! if (side == :runner) ^ (pairing.player2 == player)
    end.first
  end

  def set_side_button(player, side, pairing)
    return unless pairing.players.include? player

    value = side_value(player, side, pairing)
    active = (pairing.side.to_sym == value)

    link_to side.capitalize,
      report_tournament_round_pairing_path(
        pairing.tournament,
        pairing.round,
        pairing,
        pairing: { side: value }
      ),
      method: :post,
      class: "btn btn-sm mr-1 #{active ? 'btn-dark' : 'btn-outline-dark'}"
  end

  def presets(tournament)
    return [[3, 0], [0, 3]] if tournament.single_sided?

    [[6, 0], [3, 3], [0, 6]]
  end

  def side_options
    Pairing.sides.collect { |v, k| [v, v] }
  end

  def side_label_for(pairing, player)
    return nil unless pairing.side && pairing.players.include?(player)

    players = pairing.players
    players.reverse! if pairing.player1_is_runner?
    players.first == player ? "(Corp)" : "(Runner)"
  end
end
