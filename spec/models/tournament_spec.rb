RSpec.describe Tournament do
  let(:tournament) { create(:tournament, player_count: 4) }

  describe '#start!' do
    it 'changes tournament status to waiting' do
      tournament.start!

      expect(tournament.waiting?).to be true
    end
  end

  describe '#pair_new_round!' do
    it 'changes tournament status to playing' do
      tournament.pair_new_round!

      expect(tournament.playing?).to be true
    end

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
end
