RSpec.describe 'updating players' do
  let(:tournament) { create(:tournament, manual_seed: true) }

  before do
    tournament.players << create(:player, name: 'Jack Player')

    sign_in tournament.user
    visit tournament_players_path(tournament)
    within(all('form').last) do
      fill_in :player_name, with: 'Jill Player'
      fill_in :player_corp_identity, with: 'Jinteki: Personal Evolution'
      fill_in :player_runner_identity, with: 'Gabriel Santiago'
      check :player_first_round_bye
      fill_in :player_manual_seed, with: 3
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

  it 'can update first round bye' do
    expect(tournament.players.first.first_round_bye).to eq(true)
  end

  it 'can update manual seed' do
    expect(tournament.players.first.manual_seed).to eq(3)
  end

  it 'redirects to tournament player page' do
    expect(current_path).to eq tournament_players_path(tournament)
  end
end
