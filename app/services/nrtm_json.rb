class NrtmJson
  attr_reader :tournament

  def initialize(tournament)
    @tournament = tournament
  end

  def data
    {
      name: tournament.name,
      date: tournament.date.to_s(:db),
      cutToTop: cut_stage.players.count,
      preliminaryRounds: swiss_stage.rounds.count,
      tournamentOrganiser: {
        nrdbId: tournament.user.nrdb_id,
        nrdbUsername: tournament.user.nrdb_username
      },
      players: swiss_stage.standings.each_with_index.map do |standing, i|
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
      eliminationPlayers: cut_stage.standings.each_with_index.map do |standing, i|
        {
          id: standing.player.id,
          name: standing.name,
          rank: i+1,
          seed: standing.player.seed_in_stage(cut_stage)
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

  def swiss_stage
    tournament.stages.find_by(format: :swiss)
  end

  def swiss_pairing_data
    swiss_stage.rounds.map do |round|
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

  def cut_stage
    tournament.stages.find_by(format: :double_elim) || NilStage.new
  end

  def cut_pairing_data
    return [] unless cut_stage

    cut_stage.rounds.map do |round|
      round.pairings.map do |pairing|
        {
          table: pairing.table_number,
          player1: {
            id: pairing.player1.id,
            role: pairing.player1_side,
            winner: pairing.score1 > pairing.score2
          },
          player2: {
            id: pairing.player2.id,
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
