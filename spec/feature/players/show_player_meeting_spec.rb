RSpec.describe 'show player meeting' do
  let(:tournament) { create(:tournament) }
  let!(:jack) { create(:player, name: 'Jack', tournament: tournament) }
  let!(:jill) { create(:player, name: 'Jill', tournament: tournament) }
  let!(:snap) { create(:player, name: 'Snap', tournament: tournament) }
  let!(:crackle) { create(:player, name: 'Crackle', tournament: tournament) }
  let!(:pop) { create(:player, name: 'Pop', tournament: tournament) }

  it 'displays meeting pairings' do
    sign_in tournament.user
    visit tournament_players_path(tournament)
    click_link 'Player meeting'

    aggregate_failures do
      expect(page).to have_content('1JackJill')
      expect(page).to have_content('2SnapCrackle')
      expect(page).to have_content('3Pop')
    end
  end

end
