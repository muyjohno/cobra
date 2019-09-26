RSpec.describe 'listing rounds' do
  let(:tournament) { create(:tournament) }

  before do
    sign_in tournament.user
  end

  it 'is successful' do
    visit tournament_rounds_path(tournament)

    expect(page).to have_http_status :ok
  end

  context 'with multiple rounds' do
    let!(:round1) { create(:round, stage: tournament.current_stage, number: 1) }
    let!(:round2) { create(:round, stage: tournament.current_stage, number: 2) }

    it 'lists all rounds' do
      visit tournament_rounds_path(tournament)

      aggregate_failures do
        expect(page).to have_content('Round 1')
        expect(page).to have_content('Round 2')
      end
    end

    context 'with a lot of players' do
      before do
        round1.stage.players == create_list(:player, 65)
      end

      it 'lists only last round' do
        visit tournament_rounds_path(tournament)

        aggregate_failures do
          expect(page).not_to have_content('Round 1')
          expect(page).to have_content('Round 2')
          expect(page).to have_content(
            'Due to the number of players, only the most recent round will be '\
            'displayed on this page to help page load.'
          )
        end
      end
    end
  end
end
