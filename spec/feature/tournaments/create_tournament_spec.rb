RSpec.describe 'creating a tournament' do
  before do
    visit new_tournament_path

    fill_in 'Name', with: 'Test Tournament'
  end

  it 'creates a tournament' do
    expect do
      click_button 'Create Tournament'
    end.to change(Tournament, :count).by(1)
  end

  it 'populates the tournament correctly' do
    click_button 'Create Tournament'

    subject = Tournament.last

    expect(subject.name).to eq('Test Tournament')
  end

  it 'redirects to tournament page' do
    click_button 'Create Tournament'

    expect(page.current_path).to eq(tournament_players_path(Tournament.last))
    expect(page).to have_content('Test Tournament')
  end
end
