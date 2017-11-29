class NrtmJson
  attr_reader :tournament

  def initialize(tournament)
    @tournament = tournament
  end

  def data
    {
      name: swiss_tournament.name,
      date: tournament.date.to_s(:db),
      cutToTop: cut_standings.count,
      preliminaryRounds: swiss_tournament.rounds.count,
      tournamentOrganiser: {
        nrdbId: tournament.user.nrdb_id,
        nrdbUsername: tournament.user.nrdb_username
      },
      players: swiss_tournament.standings.each_with_index.map do |standing, i|
        {
          id: standing.player.id,
          name: standing.name,
          rank: i+1,
          corpIdentity: (standing.corp_identity.name if standing.corp_identity.id),
          runnerIdentity: (standing.runner_identity.name if standing.runner_identity.id),
          matchPoints: standing.points,
          strengthOfSchedule: standing.sos,
          extendedStrengthOfSchedule: standing.extended_sos
        }
      end,
      eliminationPlayers: cut_standings.each_with_index.map do |standing, i|
        {
          id: standing.player.previous_id,
          name: standing.name,
          rank: i+1,
          seed: standing.player.seed
        }
      end,
      rounds: swiss_pairing_data + cut_pairing_data,
      uploadedFrom: "Cobra",
      links: [
        { rel: "schemaderivedfrom", href: "http://steffens.org/nrtm/nrtm-schema.json" },
        { rel: "uploadedfrom", href: "http://cobr.ai/#{tournament.slug}" }
      ]
    }
  end

  private

  def swiss_tournament
    tournament.double_elim? ? tournament.previous : tournament
  end

  def swiss_pairing_data
    swiss_tournament.rounds.map do |round|
      round.pairings.map do |pairing|
        {
          table: pairing.table_number,
          player1: {
            id: pairing.player1_id,
            runnerScore: 0,
            corpScore: 0,
            combinedScore: pairing.score1
          },
          player2: {
            id: pairing.player2_id,
            runnerScore: 0,
            corpScore: 0,
            combinedScore: pairing.score2
          },
          intentionalDraw: false,
          eliminationGame: false
        }
      end
    end
  end

  def cut_tournament
    tournament.double_elim? ? tournament : nil
  end

  def cut_standings
    tournament.double_elim? ? tournament.standings : []
  end

  def cut_pairing_data
    return [] unless cut_tournament

    cut_tournament.rounds.map do |round|
      round.pairings.map do |pairing|
        {
          table: pairing.table_number,
          player1: {
            id: pairing.player1.previous.id,
            role: pairing.player1_side,
            winner: pairing.score1 > pairing.score2
          },
          player2: {
            id: pairing.player2.previous.id,
            role: pairing.player2_side,
            winner: pairing.score2 > pairing.score1
          },
          intentionalDraw: false,
          eliminationGame: true
        }
      end
    end
  end
end
