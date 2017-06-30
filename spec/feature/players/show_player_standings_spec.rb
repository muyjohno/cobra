RSpec.describe 'showing player standings' do
  let(:tournament) { create(:tournament) }

  before do
    sign_in tournament.user
    visit standings_tournament_players_path(tournament)
  end

  it 'displays standings' do
    expect(page).to have_content('Standings')
  end
end
