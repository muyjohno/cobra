module PairingsHelper
  def pairing_player_select(form, label, round)
    form.input label,
      collection: round.unpaired_players,
      include_blank: '(Bye)',
      label: false,
      wrapper: false
  end
end
