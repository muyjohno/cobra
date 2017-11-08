class NrtmJson
  attr_reader :tournament, :standings

  def initialize(tournament)
    @tournament = tournament
    @standings = tournament.standings
  end

  def data
    {
      name: tournament.name,
      cutToTop: 0,
      players: standings.each_with_index.map do |standing, i|
        {
          corpIdentity: standing.corp_identity,
          runnerIdentity: standing.runner_identity,
          rank: i+1,
          id: standing.player.id,
          name: standing.name,
          matchPoints: standing.points,
          strengthOfSchedule: standing.sos,
          extendedStrengthOfSchedule: standing.extended_sos
        }
      end
    }
  end
end
