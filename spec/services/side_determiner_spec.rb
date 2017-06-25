RSpec.describe SideDeterminer do
  let(:decision) { described_class.determine_sides(player1, player2) }
  let(:player1) { create(:player) }
  let(:player2) { create(:player) }

  context 'no games' do
    it 'does not set sides' do
      expect(decision).to eq(nil)
    end
  end

  context 'difference' do
    before do
      create(:pairing, player1: player1, side: :player1_is_corp, score1: 3)
      create(:pairing, player1: player2, side: :player1_is_runner, score1: 3)
    end

    it 'determines weaker side' do
      expect(decision).to eq(:player1_is_runner)
    end
  end

  context 'imbalance' do
    before do
      create(:pairing, player1: player1, side: :player1_is_corp, score1: 3)
      create(:pairing, player1: player2, side: :player1_is_corp, score1: 3)
      create(:pairing, player1: player2, side: :player1_is_corp, score1: 3)
    end

    it 'picks player who has played the overplayed side least' do
      expect(decision).to eq(:player1_is_corp)
    end
  end

  context 'some games played but tied' do
    before do
      create(:pairing, player1: player1, side: :player1_is_corp, score1: 3)
      create(:pairing, player1: player2, side: :player1_is_corp, score1: 3)
    end

    it 'randomly picks sides' do
      expect(decision).not_to eq(nil)
    end
  end
end
