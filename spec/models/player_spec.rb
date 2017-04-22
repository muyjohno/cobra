RSpec.describe Player do
  describe '#pairings' do
    let(:pairing) { create(:pairing) }
    let(:another) { create(:pairing, player2: pairing.player1) }
    let(:unrelated) { create(:pairing) }

    it 'returns correct pairings' do
      expect(pairing.player1.pairings).to eq([pairing, another])
    end
  end

  describe '#non_bye_pairings' do
    let(:player) { create(:player) }
    let!(:pairing1) { create(:pairing, player1: player) }
    let!(:pairing2) { create(:pairing, player2: player) }
    let!(:bye_pairing) { create(:pairing, player1: player, player2: nil) }

    it 'only returns non-byes' do
      expect(player.non_bye_pairings).to eq([pairing1, pairing2])
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

  describe 'opponents' do
    let(:player) { create(:player) }
    let!(:pairing1) { create(:pairing, player1: player, score1: 6) }
    let!(:pairing2) { create(:pairing, player1: player, score1: 3) }
    let!(:pairing3) { create(:pairing, player1: player, player2: nil, score1: 6) }

    describe '#opponents' do
      let(:nil_player) { instance_double('NilPlayer') }

      before do
        allow(NilPlayer).to receive(:new).and_return(nil_player)
      end

      it 'returns all opponents' do
        expect(player.opponents).to eq([pairing1.player2, pairing2.player2, nil_player])
      end
    end

    describe '#non_bye_opponents' do
      it 'returns all opponents' do
        expect(player.non_bye_opponents).to eq([pairing1.player2, pairing2.player2])
      end
    end

    describe '#points' do
      it 'returns points earned against all opponents' do
        expect(player.points).to eq(15)
      end
    end

    describe '#sos_earned' do
      it 'returns points earned against non-bye opponents' do
        expect(player.sos_earned).to eq(9)
      end
    end
  end
end
