RSpec.describe 'updating tournament' do
  let(:tournament) do
    create(:tournament, name: 'Old Tournament Name')
  end

  before do
    sign_in tournament.user
    visit edit_tournament_path(tournament)

    fill_in :tournament_name, with: 'New Tournament Name'
    fill_in :tournament_date, with: '2017/01/01'
    fill_in :tournament_stream_url, with: 'https://twitch.tv'
    check :tournament_private
    check :tournament_manual_seed
  end

  it 'updates tournament' do
    click_button 'Save'

    tournament.reload

    aggregate_failures do
      expect(tournament.name).to eq('New Tournament Name')
      expect(tournament.date.to_s).to eq('2017-01-01')
      expect(tournament.stream_url).to eq('https://twitch.tv')
      expect(tournament.private?).to eq(true)
      expect(tournament.manual_seed?).to eq(true)
    end
  end
end
