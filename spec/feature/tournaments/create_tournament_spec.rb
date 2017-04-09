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

    aggregate_failures do
      expect(subject.name).to eq('Test Tournament')
      expect(subject).to be_registering
    end
  end

  it 'redirects to tournament page' do
    click_button 'Create Tournament'

    expect(page.current_path).to eq(tournament_path(Tournament.last))
    expect(page).to have_content('Test Tournament')
  end
end
