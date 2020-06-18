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
      expect(all('input[name="player[name]"]').last.value).to eq('Jack Player')
    end

    context 'with multiple players' do
      before do
        tournament.players << create(:player, name: 'adam')
        tournament.players << create(:player, name: 'Ben')

        visit tournament_players_path(tournament)
      end

      it 'sorts players' do
        expect(all('input[name="player[name]"]').map(&:value)).to eq(
          [nil, 'adam', 'Ben', 'Jack Player']
        )
      end
    end
  end

  context 'as non-owner' do
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
