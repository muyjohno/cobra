RSpec.describe 'creating a tournament' do
  before do
    sign_in create(:user)
    visit tournaments_path

    fill_in 'Tournament Name', with: 'Test Tournament'
  end

  it 'creates a tournament' do
    expect do
      click_button 'Create'
    end.to change(Tournament, :count).by(1)
  end

  it 'populates the tournament correctly' do
    click_button 'Create'

    subject = Tournament.last

    aggregate_failures do
      expect(subject.name).to eq('Test Tournament')
      expect(subject.created_at).not_to eq(nil)
    end
  end

  it 'redirects to tournament page' do
    click_button 'Create'

    expect(page.current_path).to eq(tournament_players_path(Tournament.last))
    expect(page).to have_content('Test Tournament')
  end
end
