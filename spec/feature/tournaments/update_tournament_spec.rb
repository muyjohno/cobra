RSpec.describe 'updating tournament' do
  let(:tournament) do
    create(:tournament, name: 'Old Tournament Name', pairing_sort: :random)
  end

  before do
    sign_in tournament.user
    visit edit_tournament_path(tournament)

    fill_in :tournament_name, with: 'New Tournament Name'
    select 'ranked', from: :tournament_pairing_sort
  end

  it 'updates tournament' do
    click_button 'Save'

    tournament.reload

    aggregate_failures do
      expect(tournament.name).to eq('New Tournament Name')
      expect(tournament.pairing_sort).to eq('ranked')
    end
  end
end
