module Import
  class Tome
    attr_reader :json, :tournaments, :players, :matches, :matches_players

    def initialize(json)
      @json = clean(json)
      @tournaments = parse_entities('Tournament')
      @players = parse_entities('Participant')
      @matches = parse_entities('Match')
      @matches_players = parse_entities('MatchParticipant')
    end

    def apply(tournament)
      Tournament.transaction do
        tournament.stages.destroy_all
        tournament.players.destroy_all

        stages = {}
        swiss_stage_id = nil
        tournaments.each_with_index do |(id, tournament_data), i|
          stages[tournament_data['pk']] = tournament.stages.create!(
            number: i + 1,
            format: tournament_data['format_pk'] == 1 ? :swiss : :double_elim
          )
          swiss_stage_id = tournament_data['pk'] if tournament_data['format_pk'] == 1
        end

        players.each do |id, player_data|
          if player_data['tournament_pk'] == swiss_stage_id
            player = tournament.players.create!(
              name: "#{player_data['first_name']} #{player_data['last_name']}",
              corp_identity: Identity.guess(player_data['identity2'])&.name,
              runner_identity: Identity.guess(player_data['identity'])&.name,
              seed: nil,
              first_round_bye: false,
              active: player_data['is_active']
            )
          else
            player = tournament.players.find_by(name: "#{player_data['first_name']} #{player_data['last_name']}")
          end
          stages[player_data['tournament_pk']].players << player
          player_data['player_id'] = player.id
        end

        matches_players.each do |id, participant|
          matches[participant['match_pk']]['participants'] ||= []
          matches[participant['match_pk']]['participants'] << participant
        end

        rounds = {}
        matches.each do |id, match|
          rounds["#{match['tournament_pk']}:#{match['round']}"] ||= stages[match['tournament_pk']].rounds.create!(
            tournament_id: tournament.id,
            number: match['round'],
            completed: false
          )

          rounds["#{match['tournament_pk']}:#{match['round']}"].pairings.create!(
            player1_id: players[match['participants'][0]['participant_pk']]['player_id'],
            player2_id: players[match['participants'][1]['participant_pk']]['player_id'],
            table_number: match['order_index'] + 1,
            score1: match['participants'][0]['points_earned'],
            score2: match['participants'][1]['points_earned'],
            side: nil
          )
        end

        rounds.each do |id, round|
          round.update!(completed: true) if round.pairings.all? &:reported?
        end
      end
    end

    private

    def clean(raw)
      JSON.parse(raw.match(/.+}/).to_s)
    end

    def parse_entities(key)
      Hash[json['entityGroupMap']["#{key}:#"]['entities'].map do |entity|
        [entity['pk'], entity]
      end]
    end
  end
end
