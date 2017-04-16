RSpec.describe 'creating a player' do
  let(:tournament) { create(:tournament) }

  before do
    visit tournament_players_path(tournament)
    fill_in :player_name, with: 'Jack'
  end

  it 'creates player' do
    expect do
      click_button 'Create'
    end.to change(Player, :count).by(1)
  end

  it 'populates the player' do
    click_button 'Create'

    subject = Player.last

    aggregate_failures do
      expect(subject.name).to eq('Jack')
      expect(subject.tournament).to eq(tournament)
    end
  end

  it 'redirects to players page' do
    click_button 'Create'

    expect(page.current_path).to eq(tournament_players_path(tournament))
  end
end
