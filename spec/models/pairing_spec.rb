RSpec.describe Pairing do
  let(:jack) { create(:player) }
  let(:jill) { create(:player) }
  let(:pairing) { create(:pairing, player1: jack, player2: jill) }

  describe '#players' do
    it 'returns both players' do
      expect(pairing.players).to eq([jack, jill])
    end
  end

  describe 'nil players' do
    let(:pairing) { create(:pairing, player1: nil) }
    let(:nil_player) { double('NilPlayer') }

    before do
      allow(NilPlayer).to receive(:new).and_return(nil_player)
    end

    it 'provides null object' do
      expect(pairing.player1).to eq(nil_player)
    end
  end

  describe '.for_player' do
    let(:other) { create(:pairing) }

    it 'returns correct pairings' do
      expect(described_class.for_player(jack)).to eq([pairing])
      expect(described_class.for_player(other.player2)).to eq([other])
    end
  end
end
