RSpec.describe 'reporting scores for pairings' do
  let(:tournament) { create(:tournament) }
  let(:stage) { tournament.current_stage }
  let(:round) { create(:round, stage: stage) }
  let(:pairing) { round.pairings.last }

  before do
    tournament.players << create(:player)
    tournament.players << create(:player)
    round.pair!

    sign_in tournament.user
    visit tournament_rounds_path(tournament)
  end

  describe 'preset scores' do
    describe 'player 1 sweep' do
      it 'stores score' do
        click_link '6-0'

        pairing.reload

        aggregate_failures do
          expect(pairing.score1).to eq(6)
          expect(pairing.score1_corp).to eq(3)
          expect(pairing.score1_runner).to eq(3)
          expect(pairing.score2).to eq(0)
          expect(pairing.score2_corp).to eq(0)
          expect(pairing.score2_runner).to eq(0)
        end
      end
    end

    describe 'player 2 sweep' do
      it 'stores score' do
        click_link '0-6'

        pairing.reload

        aggregate_failures do
          expect(pairing.score1).to eq(0)
          expect(pairing.score1_corp).to eq(0)
          expect(pairing.score1_runner).to eq(0)
          expect(pairing.score2).to eq(6)
          expect(pairing.score2_corp).to eq(3)
          expect(pairing.score2_runner).to eq(3)
        end
      end
    end

    describe 'corp split' do
      it 'stores score' do
        click_link '3-3 (C)'

        pairing.reload

        aggregate_failures do
          expect(pairing.score1).to eq(3)
          expect(pairing.score1_corp).to eq(3)
          expect(pairing.score1_runner).to eq(0)
          expect(pairing.score2).to eq(3)
          expect(pairing.score2_corp).to eq(3)
          expect(pairing.score2_runner).to eq(0)
        end
      end
    end

    describe 'runner split' do
      it 'stores score' do
        click_link '3-3 (R)'

        pairing.reload

        aggregate_failures do
          expect(pairing.score1).to eq(3)
          expect(pairing.score1_corp).to eq(0)
          expect(pairing.score1_runner).to eq(3)
          expect(pairing.score2).to eq(3)
          expect(pairing.score2_corp).to eq(0)
          expect(pairing.score2_runner).to eq(3)
        end
      end
    end

    context 'for single_sided pairing' do
      before { stage.update(format: :double_elim) }

      describe 'player 1 is corp' do
        before do
          pairing.update(side: :player1_is_corp)
          visit tournament_rounds_path(tournament)
        end

        describe 'player 1 wins' do
          it 'stores score' do
            click_link '3-0'

            pairing.reload

            aggregate_failures do
              expect(pairing.score1).to eq(3)
              expect(pairing.score1_corp).to eq(3)
              expect(pairing.score1_runner).to eq(0)
              expect(pairing.score2).to eq(0)
              expect(pairing.score2_corp).to eq(0)
              expect(pairing.score2_runner).to eq(0)
            end
          end
        end

        describe 'player 2 wins' do
          it 'stores score' do
            click_link '0-3'

            pairing.reload

            aggregate_failures do
              expect(pairing.score1).to eq(0)
              expect(pairing.score1_corp).to eq(0)
              expect(pairing.score1_runner).to eq(0)
              expect(pairing.score2).to eq(3)
              expect(pairing.score2_corp).to eq(0)
              expect(pairing.score2_runner).to eq(3)
            end
          end
        end
      end

      describe 'player 1 is runner' do
        before do
          pairing.update(side: :player1_is_runner)
          visit tournament_rounds_path(tournament)
        end

        describe 'player 1 wins' do
          it 'stores score' do
            click_link '3-0'

            pairing.reload

            aggregate_failures do
              expect(pairing.score1).to eq(3)
              expect(pairing.score1_corp).to eq(0)
              expect(pairing.score1_runner).to eq(3)
              expect(pairing.score2).to eq(0)
              expect(pairing.score2_corp).to eq(0)
              expect(pairing.score2_runner).to eq(0)
            end
          end
        end

        describe 'player 2 wins' do
          it 'stores score' do
            click_link '0-3'

            pairing.reload

            aggregate_failures do
              expect(pairing.score1).to eq(0)
              expect(pairing.score1_corp).to eq(0)
              expect(pairing.score1_runner).to eq(0)
              expect(pairing.score2).to eq(3)
              expect(pairing.score2_corp).to eq(3)
              expect(pairing.score2_runner).to eq(0)
            end
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

      pairing.reload

      aggregate_failures do
        expect(pairing.score1).to eq(4)
        expect(pairing.score1_corp).to eq(0)
        expect(pairing.score1_runner).to eq(0)
        expect(pairing.score2).to eq(1)
        expect(pairing.score2_corp).to eq(0)
        expect(pairing.score2_runner).to eq(0)
      end
    end

    it 'blanks pre-existing side scores' do
      pairing.update(score1_runner: 3)

      visit tournament_rounds_path(tournament)
      fill_in :pairing_score1, with: '4'
      fill_in :pairing_score2, with: '1'
      click_button 'Save'

      pairing.reload

      aggregate_failures do
        expect(pairing.score1).to eq(4)
        expect(pairing.score1_corp).to eq(0)
        expect(pairing.score1_runner).to eq(0)
        expect(pairing.score2).to eq(1)
        expect(pairing.score2_corp).to eq(0)
        expect(pairing.score2_runner).to eq(0)
      end
    end
  end
end
