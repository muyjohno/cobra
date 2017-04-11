RSpec.describe 'listing players' do
  let(:tournament) { create(:tournament) }

  before do
    tournament.players << create(:player, name: 'Jack Player')

    visit tournament_players_path(tournament)
  end

  it 'lists players' do
    expect(page).to have_content('Jack Player')
  end
end
