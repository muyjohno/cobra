RSpec.describe Round do
  let(:round) { create(:round) }
  let(:pairer) { double('Pairer', pair!: true) }

  before do
    allow(Pairer).to receive(:new).and_return(pairer)
  end

  describe '#pair!' do
    it 'invokes Pairer' do
      round.pair!

      expect(Pairer).to have_received(:new).with(round)
      expect(pairer).to have_received(:pair!)
    end
  end

  describe '#unpaired_players' do
    let!(:snap) { create(:player, tournament: tournament) }
    let!(:crackle) { create(:player, tournament: tournament) }
    let!(:pop) { create(:player, tournament: tournament) }
    let(:tournament) { round.tournament }

    before do
      round.pairings.create(player1: snap, player2: crackle)
    end

    it 'returns players who have not been paired' do
      expect(round.unpaired_players).to eq([pop])
    end
  end

  describe '#repair!' do
    before do
      round.pairings << create(:pairing)
    end

    it 'destroys pairings' do
      expect do
        round.repair!
      end.to change(round.pairings, :count).by(-1)
    end

    it 'invokes pairer' do
      round.repair!

      expect(Pairer).to have_received(:new)
      expect(pairer).to have_received(:pair!)
    end
  end
end
