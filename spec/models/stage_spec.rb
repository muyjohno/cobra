RSpec.describe Stage do
  let(:tournament) { create(:tournament) }
  let(:stage) { create(:stage, tournament: tournament) }

  describe '#pair_new_round!' do
    it 'creates new round with pairings' do
      expect do
        round = stage.pair_new_round!

        expect(
          round.pairings.map(&:players).flatten
        ).to match_array(tournament.players)
      end.to change(stage.rounds, :count).by(1)
    end

    describe 'round numbers' do
      it 'creates first with number 1' do
        expect(stage.pair_new_round!.number).to eq(1)
      end

      it 'adds to previous highest' do
        round = create(:round, stage: stage, number: 4)

        expect(stage.pair_new_round!.number).to eq(5)
      end
    end
  end
end
