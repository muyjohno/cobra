RSpec.describe SosCalculator do
  let(:snap) { create(:player) }
  let(:crackle) { create(:player) }
  let(:pop) { create(:player) }
  let(:other) { create(:player) }

  context 'no opponents' do
    it 'calculates sos' do
      expect(described_class.sos(snap)).to eq(0)
    end

    it 'calculates extended sos' do
      expect(described_class.extended_sos(snap)).to eq(0)
    end
  end

  context 'with opponents' do
    before do
      create(:pairing, player1: snap, player2: crackle, score1: 6, score2: 0)
      create(:pairing, player1: pop, player2: other, score1: 6, score2: 0)

      create(:pairing, player1: snap, player2: pop, score1: 6, score2: 0)
      create(:pairing, player1: crackle, player2: other, score1: 3, score2: 3)
    end

    it 'calculates sos' do
      expect(described_class.sos(snap)).to eq(2.25)
    end

    it 'calculates extended sos' do
      expect(described_class.extended_sos(snap)).to eq(3.75)
    end
  end
end
