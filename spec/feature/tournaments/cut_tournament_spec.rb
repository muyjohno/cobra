RSpec.describe 'cutting tournament' do
  let(:tournament) do
    create(:tournament, player_count: 10)
  end

  context 'as guest' do
    context 'on rounds page' do
      before do
        visit tournament_rounds_path(tournament)
      end

      it 'does not display link' do
        expect(page).not_to have_content('Cut to Top')
      end
    end
  end

  context 'as tournament owner' do
    before do
      sign_in tournament.user
    end

    context 'on settings page' do
      before do
        visit edit_tournament_path(tournament)
      end

      it 'creates double elim stage' do
        expect do
          click_button 'Cut to Top 4'
        end.to change(tournament.stages, :count).by(1)
      end
    end

    context 'on rounds page' do
      before do
        visit tournament_rounds_path(tournament)
      end

      it 'creates double elim stage' do
        expect do
          click_link 'Cut to Top 8'
        end.to change(tournament.stages, :count).by(1)
      end
    end
  end
end
