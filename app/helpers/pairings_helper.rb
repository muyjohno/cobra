module PairingsHelper
  def pairing_player_select(form, label, round)
    form.input label,
      collection: round.unpaired_players,
      include_blank: '(Bye)',
      label: false,
      wrapper: false
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
      class: 'pure-button'
  end

  def presets(tournament)
    return [[3, 0], [0, 3]] if tournament.double_elim?

    [[6, 0], [3, 3], [0, 6]]
  end
end
