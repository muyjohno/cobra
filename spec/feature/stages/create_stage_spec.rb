RSpec.describe 'creating a stage' do
  let(:tournament) { create(:tournament, player_count: 4) }

  before do
    tournament.current_stage.destroy
  end

  context 'as tournament owner' do
    before do
      sign_in tournament.user
      visit tournament_rounds_path(tournament)
    end

    it 'creates new stage' do
      expect do
        click_link 'Add Swiss stage'
      end.to change(Stage, :count).by(1)

      stage = tournament.reload.current_stage
      expect(stage.format).to eq('swiss')
      expect(stage.players.count).to eq(4)
    end
  end

  context 'as guest' do
    before do
      visit tournament_rounds_path(tournament)
    end

    it 'creates new stage' do
      expect(page).not_to have_content('Add Swiss stage')
    end
  end
end
