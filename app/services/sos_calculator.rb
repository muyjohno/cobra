class SosCalculator
  def self.calculate!(stage)
    players = Hash[stage.players.map{ |p| [p.id, p] }]

    # calculate points and cache values for sos calculations
    points = {}
    games_played = {}
    opponents = {}
    points_for_sos = {}
    corp_points = {}
    runner_points = {}
    stage.eligible_pairings.each do |p|
      points[p.player1_id] ||= 0
      points[p.player1_id] += p.score1 || 0
      points[p.player2_id] ||= 0
      points[p.player2_id] += p.score2 || 0
      games_played[p.player1_id] ||= 0
      games_played[p.player1_id] += p.round.weight
      games_played[p.player2_id] ||= 0
      games_played[p.player2_id] += p.round.weight
      opponents[p.player1_id] ||= []
      opponents[p.player1_id] << { id: p.player2_id, weight: p.round.weight }
      opponents[p.player2_id] ||= []
      opponents[p.player2_id] << { id: p.player1_id, weight: p.round.weight }
      points_for_sos[p.player1_id] ||= 0
      points_for_sos[p.player1_id] += p.score1 || 0
      points_for_sos[p.player2_id] ||= 0
      points_for_sos[p.player2_id] += p.score2 || 0
      corp_points[p.player1_id] ||= 0
      corp_points[p.player1_id] += p.score1_corp || 0
      corp_points[p.player2_id] ||= 0
      corp_points[p.player2_id] += p.score2_corp || 0
      runner_points[p.player1_id] ||= 0
      runner_points[p.player1_id] += p.score1_runner || 0
      runner_points[p.player2_id] ||= 0
      runner_points[p.player2_id] += p.score2_runner || 0
    end

    # filter out byes from sos calculations
    opponents.each do |k, i|
      opponents[k] = i.select { |player| player[:id] }
    end

    sos = {}
    opponents.each do |id, o|
      if o.any?
        sos[id] = o.sum do |player|
          player[:weight] * points_for_sos[player[:id]].to_f / games_played[player[:id]]
        end.to_f / o.inject(0) { |i, player| i += player[:weight] if player[:id] }
      else
        sos[id] = 0.0
      end
    end

    extended_sos = {}
    opponents.each do |id, o|
      if o.any?
        extended_sos[id] = o.sum do |player|
          player[:weight] * sos[player[:id]]
        end.to_f / o.inject(0) { |i, player| i += player[:weight] if player[:id] }
      else
        extended_sos[id] = 0.0
      end
    end

    players.values.map do |p|
      Standing.new(p,
        points: points[p.id],
        sos: sos[p.id],
        extended_sos: extended_sos[p.id],
        corp_points: corp_points[p.id],
        runner_points: runner_points[p.id]
      )
    end.sort
  end
end
