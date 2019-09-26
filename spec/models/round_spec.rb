RSpec.describe Round do
  let(:round) { create(:round) }
  let(:pairer) { double('Pairer', pair!: true) }

  before do
    allow(Pairer).to receive(:new).and_return(pairer)
  end

  describe 'ordering' do
    before do
      create(:pairing, round: round, table_number: 2)
      create(:pairing, round: round, table_number: 1)
      create(:pairing, round: round, table_number: 3)
    end

    it 'returns pairings by table' do
      expect(round.pairings.map(&:table_number)).to eq([1,2,3])
    end
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

  describe '#collated_pairings' do
    let(:round) { create(:round) }

    context 'with some pairings' do
      let!(:pairing1) { create(:pairing, round: round) }
      let!(:pairing2) { create(:pairing, round: round) }
      let!(:pairing3) { create(:pairing, round: round) }
      let!(:pairing4) { create(:pairing, round: round) }
      let!(:pairing5) { create(:pairing, round: round) }
      let!(:pairing6) { create(:pairing, round: round) }
      let!(:pairing7) { create(:pairing, round: round) }
      let!(:pairing8) { create(:pairing, round: round) }
      let!(:pairing9) { create(:pairing, round: round) }
      let!(:pairing10) { create(:pairing, round: round) }
      let!(:pairing11) { create(:pairing, round: round) }
      let!(:pairing12) { create(:pairing, round: round) }
      let!(:pairing13) { create(:pairing, round: round) }

      it 'returns sorted pairings' do
        expect(round.collated_pairings).to match_array([
          pairing1, pairing5, pairing9, pairing13,
          pairing2, pairing6, pairing10, nil,
          pairing3, pairing7, pairing11, nil,
          pairing4, pairing8, pairing12, nil
        ])
      end
    end

    context 'with few pairings' do
      let!(:pairing1) { create(:pairing, round: round) }
      let!(:pairing2) { create(:pairing, round: round) }

      it 'returns sorted pairings' do
        expect(round.collated_pairings).to match_array([
          pairing1, pairing2
        ])
      end
    end

    context 'with many pairings' do
      let!(:pairing1) { create(:pairing, round: round) }
      let!(:pairing2) { create(:pairing, round: round) }
      let!(:pairing3) { create(:pairing, round: round) }
      let!(:pairing4) { create(:pairing, round: round) }
      let!(:pairing5) { create(:pairing, round: round) }
      let!(:pairing6) { create(:pairing, round: round) }
      let!(:pairing7) { create(:pairing, round: round) }
      let!(:pairing8) { create(:pairing, round: round) }
      let!(:pairing9) { create(:pairing, round: round) }
      let!(:pairing10) { create(:pairing, round: round) }
      let!(:pairing11) { create(:pairing, round: round) }
      let!(:pairing12) { create(:pairing, round: round) }
      let!(:pairing13) { create(:pairing, round: round) }
      let!(:pairing14) { create(:pairing, round: round) }
      let!(:pairing15) { create(:pairing, round: round) }
      let!(:pairing16) { create(:pairing, round: round) }
      let!(:pairing17) { create(:pairing, round: round) }
      let!(:pairing18) { create(:pairing, round: round) }
      let!(:pairing19) { create(:pairing, round: round) }
      let!(:pairing20) { create(:pairing, round: round) }
      let!(:pairing21) { create(:pairing, round: round) }
      let!(:pairing22) { create(:pairing, round: round) }
      let!(:pairing23) { create(:pairing, round: round) }
      let!(:pairing24) { create(:pairing, round: round) }
      let!(:pairing25) { create(:pairing, round: round) }
      let!(:pairing26) { create(:pairing, round: round) }

      it 'returns sorted pairings' do
        expect(round.collated_pairings).to match_array([
          pairing1, pairing8, pairing15, pairing22,
          pairing2, pairing9, pairing16, pairing23,
          pairing3, pairing10, pairing17, pairing24,
          pairing4, pairing11, pairing18, pairing25,
          pairing5, pairing12, pairing19, pairing26,
          pairing6, pairing13, pairing20, nil,
          pairing7, pairing14, pairing21, nil,
        ])
      end
    end
  end

  describe '#cache_standings!' do
    before do
      allow(round.stage).to receive(:cache_standings!)
    end

    context 'when completed' do
      let(:round) { create(:round, completed: true) }

      it 'is not called' do
        round.update(completed: true)

        expect(round.stage).not_to have_received(:cache_standings!)
      end
    end

    context 'when not completed' do
      let(:round) { create(:round, completed: false) }

      it 'is called when round is completed' do
        round.update(completed: true)

        expect(round.stage).to have_received(:cache_standings!)
      end

      it 'is not called when round remains incomplete' do
        round.update(number: 1)

        expect(round.stage).not_to have_received(:cache_standings!)
      end
    end
  end
end
