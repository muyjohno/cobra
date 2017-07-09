RSpec.describe SosCalculator do
  let(:tournament) { create(:tournament) }
  let!(:snap) { create(:player, tournament: tournament) }
  let!(:crackle) { create(:player, tournament: tournament) }
  let!(:pop) { create(:player, tournament: tournament) }
  let!(:other) { create(:player, tournament: tournament) }
  let(:results) { described_class.calculate!(tournament) }
  let(:standing) { results.find{ |p| p.player == snap }}

  context 'with opponents' do

    before do
      create(:pairing, player1: snap, player2: crackle, score1: 6, score2: 0)
      create(:pairing, player1: pop, player2: other, score1: 6, score2: 0)

      create(:pairing, player1: snap, player2: pop, score1: 6, score2: 0)
      create(:pairing, player1: crackle, player2: other, score1: 3, score2: 3)
    end

    it 'calculates sos' do
      expect(standing.sos).to eq(2.25)
    end

    it 'calculates extended sos' do
      expect(standing.extended_sos).to eq(3.75)
    end
  end

  describe 'points' do
    before do
      create(:pairing, player1: snap, score1: 5)
      create(:pairing, player1: snap, score1: 2, player2: nil)
    end

    it 'returns total of all points from pairings including byes' do
      expect(standing.points).to eq(7)
    end
  end

  describe 'sos' do
    before do
      other = create(:player)
      # player played two games, including against opponent 'other'
      create(:pairing, player1: snap, player2: other, score1: 3, score2: 2)
      create(:pairing, player1: snap, score1: 1, score2: 3)
      # other played one other eligible game
      create(:pairing, player2: other, score1: 0, score2: 5)
    end

    it 'calculates sos' do
      expect(standing.sos).to eq(3.25)
    end

    describe 'extended_sos' do
      it 'calculates extended sos' do
        expect(standing.extended_sos).to eq(1.5)
      end
    end
  end

  context 'player with only byes' do
    before do
      create(:pairing, player1: snap, player2: nil, score1: 6, score2: 0)
    end

    it 'calculates standing' do
      aggregate_failures do
        expect(standing.points).to eq(6)
        expect(standing.sos).to eq(0.0)
        expect(standing.extended_sos).to eq(0.0)
      end
    end
  end
end
