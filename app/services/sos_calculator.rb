class SosCalculator
  def self.calculate!(tournament)
    players = Hash[tournament.players.map{ |p| [p.id, p] }]

    # calculate points and cache values for sos calculations
    points = {}
    games_played = {}
    opponents = {}
    points_for_sos = {}
    tournament.players.map(&:pairings).flatten.uniq.each do |p|
      points[p.player1_id] ||= 0
      points[p.player1_id] += p.score1 || 0
      points[p.player2_id] ||= 0
      points[p.player2_id] += p.score2 || 0
      games_played[p.player1_id] ||= 0
      games_played[p.player1_id] += 1
      games_played[p.player2_id] ||= 0
      games_played[p.player2_id] += 1
      opponents[p.player1_id] ||= []
      opponents[p.player1_id] << p.player2_id
      opponents[p.player2_id] ||= []
      opponents[p.player2_id] << p.player1_id
      points_for_sos[p.player1_id] ||= 0
      points_for_sos[p.player1_id] += p.score1 || 0
      points_for_sos[p.player2_id] ||= 0
      points_for_sos[p.player2_id] += p.score2 || 0
    end

    # filter out byes from sos calculations
    opponents.each do |k, i|
      opponents[k] = i.compact
    end

    sos = {}
    opponents.each do |id, o|
      if o.any?
        sos[id] = o.sum do |player|
          points_for_sos[player].to_f / games_played[player]
        end.to_f / o.count
      else
        sos[id] = 0.0
      end
    end

    extended_sos = {}
    opponents.each do |id, o|
      if o.any?
        extended_sos[id] = o.sum do |player|
          sos[player]
        end.to_f / o.count
      else
        extended_sos[id] = 0.0
      end
    end

    players.values.map do |p|
      Standing.new(p,
        points: points[p.id],
        sos: sos[p.id],
        extended_sos: extended_sos[p.id]
      )
    end.sort
  end
end
