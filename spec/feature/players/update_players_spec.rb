RSpec.describe 'updating players' do
  let(:tournament) { create(:tournament) }

  before do
    tournament.players << create(:player, name: 'Jack Player')

    visit tournament_players_path(tournament)
    within(find('table tbody').first('tr')) do
      fill_in 'player[name]', with: 'Jill Player'
      click_button 'Update'
    end
  end

  it 'can update player name' do
    expect(tournament.players.first.name).to eq('Jill Player')
  end

  it 'redirects to tournament player page' do
    expect(current_path).to eq tournament_players_path(tournament)
  end
end
