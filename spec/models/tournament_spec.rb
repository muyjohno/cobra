RSpec.describe Tournament do
  let(:tournament) { create(:tournament, player_count: 4) }

  describe '#pair_new_round!' do
    it 'creates new round with pairings' do
      expect do
        round = tournament.pair_new_round!

        expect(
          round.pairings.map(&:players).flatten
        ).to match_array(tournament.players)
      end.to change(tournament.rounds, :count).by(1)
    end

    describe 'round numbers' do
      it 'creates first with number 1' do
        expect(tournament.pair_new_round!.number).to eq(1)
      end

      it 'adds to previous highest' do
        create(:round, tournament: tournament, number: 4)

        expect(tournament.pair_new_round!.number).to eq(5)
      end
    end
  end

  describe '#standings' do
    let(:standings) { instance_double('Standings') }

    before do
      allow(Standings).to receive(:new).and_return(standings)
    end

    it 'returns standings object' do
      expect(tournament.standings).to eq(standings)
      expect(Standings).to have_received(:new).with(tournament)
    end
  end

  describe '#pairing_sorter' do
    context 'random' do
      let(:tournament) { create(:tournament, pairing_sort: :random) }

      it 'returns correct class' do
        expect(tournament.pairing_sorter).to eq(PairingSorters::Random)
      end
    end

    context 'ranked' do
      let(:tournament) { create(:tournament, pairing_sort: :ranked) }

      it 'returns correct class' do
        expect(tournament.pairing_sorter).to eq(PairingSorters::Ranked)
      end
    end
  end
end
