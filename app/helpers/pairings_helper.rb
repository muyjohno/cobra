module PairingsHelper
  def pairing_player_select(form, label, round)
    form.input label,
      collection: round.unpaired_players,
      include_blank: '(Bye)',
      label: false,
      wrapper: false,
      input_html: { class: 'form-control mx-2' }
  end

  def preset_score_button(pairing, data)
    link_to data[:label],
      report_tournament_round_pairing_path(
        pairing.tournament,
        pairing.round,
        pairing,
        pairing: data
      ),
      method: :post,
      class: 'btn btn-primary'
  end

  def side_value(player, side, pairing)
    return unless player_is_in_pairing(player, pairing)

    [:player1_is_corp, :player1_is_runner].tap do |options|
      options.reverse! if (side == :runner) ^ (pairing.player2 == player)
    end.first
  end

  def set_side_button(player, side, pairing)
    return unless player_is_in_pairing(player, pairing)

    value = side_value(player, side, pairing)
    active = (pairing.side.try(:to_sym) == value)

    link_to side.capitalize,
      report_tournament_round_pairing_path(
        pairing.tournament,
        pairing.round_id,
        pairing,
        pairing: { side: value }
      ),
      method: :post,
      class: "btn btn-sm mr-1 #{active ? 'btn-dark' : 'btn-outline-dark'}"
  end

  def presets(pairing)
    return [
      { score1_corp: 3, score2_runner: 0, score1_runner: 3, score2_corp: 0, label: '6-0' },
      { score1_corp: 3, score2_runner: 0, score1_runner: 0, score2_corp: 3, label: '3-3 (C)' },
      { score1_corp: 0, score2_runner: 3, score1_runner: 3, score2_corp: 0, label: '3-3 (R)' },
      { score1_corp: 0, score2_runner: 3, score1_runner: 0, score2_corp: 3, label: '0-6' }
    ] unless pairing.stage.single_sided?

    return [
      { score1_corp: 3, score2_runner: 0, score1_runner: 0, score2_corp: 0, label: '3-0' },
      { score1_corp: 0, score2_runner: 3, score1_runner: 0, score2_corp: 0, label: '0-3' }
    ] if pairing.side.try(:to_sym) == :player1_is_corp

    return [
      { score1_corp: 0, score2_runner: 0, score1_runner: 3, score2_corp: 0, label: '3-0' },
      { score1_corp: 0, score2_runner: 0, score1_runner: 0, score2_corp: 3, label: '0-3' }
    ] if pairing.side.try(:to_sym) == :player1_is_runner

    [
      { score1: 3, score2: 0, score1_corp: 0, score2_runner: 0, score1_runner: 0, score2_corp: 0, label: '3-0' },
      { score1: 0, score2: 3, score1_corp: 0, score2_runner: 0, score1_runner: 0, score2_corp: 0, label: '0-3' }
    ]
  end

  def side_options
    Pairing.sides.collect { |v, k| [v, v] }
  end

  def side_label_for(pairing, player)
    return nil unless pairing.side && player_is_in_pairing(player, pairing)

    "(#{pairing.side_for(player).to_s.titleize})"
  end

  def player_is_in_pairing(player, pairing)
    pairing.player1_id == player.id || pairing.player2_id == player.id
  end
end
