RSpec.describe Round do
  let(:round) { create(:round) }
  let(:pairer) { double('Pairer', pair!: true) }

  describe '#pair!' do
    before do
      allow(Pairer).to receive(:new).and_return(pairer)
    end

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
end
