RSpec.describe 'reporting scores for pairings' do
  let(:tournament) { create(:tournament) }
  let(:stage) { tournament.current_stage }
  let(:round) { create(:round, stage: stage) }

  before do
    tournament.players << create(:player)
    tournament.players << create(:player)
    round.pair!

    sign_in tournament.user
    visit tournament_rounds_path(tournament)
  end

  describe 'preset scores' do
    [[6,0], [3,3], [0,6]].each do |score|
      score1 = score[0]
      score2 = score[1]

      describe "#{score1}-#{score2}" do
        it 'stores score' do
          click_link "#{score1}-#{score2}"

          pairing = Pairing.last

          aggregate_failures do
            expect(pairing.score1).to eq(score1)
            expect(pairing.score2).to eq(score2)
          end
        end
      end
    end
  end

  describe 'custom scores' do
    it 'stores score' do
      fill_in :pairing_score1, with: '4'
      fill_in :pairing_score2, with: '1'
      click_button 'Save'

      pairing = Pairing.last

      aggregate_failures do
        expect(pairing.score1).to eq(4)
        expect(pairing.score2).to eq(1)
      end
    end
  end
end
