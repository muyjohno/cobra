RSpec.describe 'load testing' do
  ROUNDS = 10
  PLAYERS = 200

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
    puts "\tDone. Took #{timer} seconds"
    ROUNDS.times do |i|
      puts "Round #{i+1}"
      puts "\tPairing #{tournament.players.active.count} players"
      round = tournament.pair_new_round!
      puts "\t\tDone. Took #{timer} seconds"
      puts "\tGenerating results"
      round.pairings.each do |p|
        # visit tournament_rounds_path(tournament)
        p.update(score1: rand(0..6), score2: rand(0..6))
      end
      expect(round.pairings.map(&:players).flatten.map(&:id) - [nil]).to match_array(tournament.players.active.map(&:id))
      tournament.players.active.shuffle.take(3).each { |p| p.update(active: false) }
      round.update(completed: true)
      puts "\t\tDone. Took #{timer} seconds"
      puts "\tCalculating standings"
      visit standings_tournament_players_path(tournament)
      puts "\t\tDone. Took #{timer} seconds"
    end
  end
end
