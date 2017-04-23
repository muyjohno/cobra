RSpec.describe 'updating tournament' do
  let(:tournament) { create(:tournament, name: 'Old Tournament Name') }

  before do
    visit edit_tournament_path(tournament)

    fill_in :tournament_name, with: 'New Tournament Name'
  end

  it 'updates tournament' do
    click_button 'Save'

    expect(tournament.reload.name).to eq('New Tournament Name')
  end
end
