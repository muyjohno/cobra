RSpec.describe Pairing do
  describe '#players' do
    let(:jack) { create(:player) }
    let(:jill) { create(:player) }
    let(:pairing) { create(:pairing, player1: jack, player2: jill) }

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
end
