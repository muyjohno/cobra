RSpec.describe Player do
  describe '#pairings' do
    let(:pairing) { create(:pairing) }
    let(:another) { create(:pairing, player2: pairing.player1) }
    let(:unrelated) { create(:pairing) }

    it 'returns correct pairings' do
      expect(pairing.player1.pairings).to eq([pairing, another])
    end
  end

  describe 'dependent pairings' do
    let!(:pairing) { create(:pairing) }

    it 'deletes pairings on delete' do
      expect do
        pairing.player1.destroy
      end.to change(Pairing, :count).by(-1)
    end
  end
end
