module TournamentHelper
  def short_date(tournament)
    return unless tournament.created_at

    tournament.created_at.strftime('%-d %b %Y')
  end
end
