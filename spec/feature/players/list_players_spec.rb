RSpec.describe 'Listing players' do
  let(:tournament) { create(:tournament) }

  before do
    tournament.players << create(:player, name: 'Jack Player')
  end

  context 'as owner' do
    before do
      sign_in tournament.user
      visit tournament_players_path(tournament)
    end

    it 'lists players' do
      expect(first('input[name="player[name]"]').value).to eq('Jack Player')
    end
  end

  context 'as owner' do
    before do
      sign_in create(:user)
      visit tournament_players_path(tournament)
    end

    it 'redirects away' do
      expect(page.current_path).to eq(root_path)
      expect(page).to have_content("Sorry, you can't do that")
    end
  end
end
