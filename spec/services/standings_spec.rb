RSpec.describe Standings do
  let(:tournament) { create(:tournament) }
  let!(:jack) { create(:player, tournament: tournament) }
  let!(:jill) { create(:player, tournament: tournament) }
  let!(:hansel) { create(:player, tournament: tournament) }
  let!(:gretel) { create(:player, tournament: tournament) }
  let(:round1) { create(:round, tournament: tournament) }
  let(:round2) { create(:round, tournament: tournament) }
  let(:standings) { described_class.new(tournament.reload) }

  before do
    round1.pairings << create(:pairing, player1: jack, player2: jill, score1: 6, score2: 0)
    round1.pairings << create(:pairing, player1: hansel, player2: gretel, score1: 3, score2: 3)
    round2.pairings << create(:pairing, player1: jack, player2: hansel, score1: 0, score2: 6)
    round2.pairings << create(:pairing, player1: gretel, player2: jill, score1: 6, score2: 0)
  end

  describe '#players' do
    it 'ranks players' do
      expect(standings.players.map(&:player)).to eq([hansel, gretel, jack, jill])
    end
  end
end
