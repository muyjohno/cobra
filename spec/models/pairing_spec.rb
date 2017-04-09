RSpec.describe Pairing do
  describe '#players' do
    let(:jack) { create(:player) }
    let(:jill) { create(:player) }
    let(:pairing) { create(:pairing, player1: jack, player2: jill) }

    it 'returns both players' do
      expect(pairing.players).to eq([jack, jill])
    end
  end
end
