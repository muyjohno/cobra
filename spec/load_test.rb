RSpec.describe 'load testing' do
  ROUNDS = 9
  PLAYERS = 350

  let(:tournament) { create(:tournament) }

  def timer
    (Time.now-(@start || Time.now)).seconds.tap do
      @start = Time.now
    end
  end

  it 'can handle load' do
    timer
    sign_in tournament.user
    puts 'Creating players'
    PLAYERS.times { create(:player, tournament: tournament) }
    expect(tournament.players.count).to equal(PLAYERS)
    puts "\tDone. Took #{timer} seconds"

    active_players = PLAYERS
    ROUNDS.times do |i|
      puts "Round #{i+1}"

      puts "\tPairing #{tournament.players.active.count} players"
      round = tournament.pair_new_round!
      puts "\t\tDone. Took #{timer} seconds"
      expect(round.pairings.count).to eq((active_players / 2.0).ceil)
      players = round.pairings.map(&:players).flatten
      expect(players.map(&:id) - [nil]).to match_array(tournament.players.active.map(&:id))
      expect(players.select { |p| p.is_a? NilPlayer }.length).to be < 2

      puts "\tGenerating results"
      round.pairings.each do |p|
        score = [[6, 0], [4, 1], [3, 3], [0, 6]].sample
        # visit tournament_rounds_path(tournament)
        p.update(score1: score.first, score2: score.last)
      end
      tournament.players.active.shuffle.take(3).each { |p| p.update(active: false) }
      active_players -= 3
      round.update(completed: true)
      puts "\t\tDone. Took #{timer} seconds"

      puts "\tCalculating standings"
      10.times do
        visit standings_tournament_players_path(tournament)
        puts "\t\tDone. Took #{timer} seconds"
      end
    end

    tournament.players.each do |player|
      if player.opponents.uniq.length != player.pairings.count
        puts "Player #{player.name} (#{player.active? ? :active : :dropped}) had #{player.opponents.uniq.length}/#{player.pairings.count} unique opponents:"
        player.pairings.each do |pairing|
          opp = pairing.opponent_for(player)
          puts "\t#{pairing.round.number}: #{opp.name}"
        end
      end
    end
  end
end
