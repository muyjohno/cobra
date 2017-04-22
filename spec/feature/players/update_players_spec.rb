RSpec.describe 'updating players' do
  let(:tournament) { create(:tournament) }

  before do
    tournament.players << create(:player, name: 'Jack Player')

    visit tournament_players_path(tournament)
    within(first('form')) do
      fill_in :player_name, with: 'Jill Player'
      fill_in :player_corp_identity, with: 'Jinteki: Personal Evolution'
      fill_in :player_runner_identity, with: 'Gabriel Santiago'
      click_button 'Save'
    end
  end

  it 'can update player name' do
    expect(tournament.players.first.name).to eq('Jill Player')
  end

  it 'can update player corp' do
    expect(tournament.players.first.corp_identity).to eq('Jinteki: Personal Evolution')
  end

  it 'can update player runner' do
    expect(tournament.players.first.runner_identity).to eq('Gabriel Santiago')
  end

  it 'redirects to tournament player page' do
    expect(current_path).to eq tournament_players_path(tournament)
  end
end
