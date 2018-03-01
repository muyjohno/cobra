RSpec.describe 'load testing' do
  ROUNDS = 10
  PLAYERS = 150

  let(:tournament) { create(:tournament) }

  def timer
    (Time.now-(@start || Time.now)).seconds.tap do
      @start = Time.now
    end
  end

  it 'can handle load' do
    timer
    puts 'Creating players'
    PLAYERS.times { create(:player, tournament: tournament) }
    puts "\tDone. Took #{timer} seconds"
    ROUNDS.times do |i|
      puts "Creating and pairing round #{i+1}"
      round = tournament.pair_new_round!
      puts "\tDone. Took #{timer} seconds"
      puts 'Generating results'
      round.pairings.each do |p|
        p.update(score1: rand(0..6), score2: rand(0..6))
      end
      puts "\tDone. Took #{timer} seconds"
    end
    puts 'Calculating standings'
    tournament.standings.players #calculate standings to test, we don't need them
    puts "\tDone. Took #{timer} seconds"
  end
end
