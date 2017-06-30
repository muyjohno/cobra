RSpec.describe 'listing players' do
  let(:tournament) { create(:tournament) }

  before do
    tournament.players << create(:player, name: 'Jack Player')
    tournament.players << create(:player)
    tournament.players << create(:player, active: false)

    sign_in tournament.user
    visit tournament_players_path(tournament)
  end

  it 'displays count' do
    expect(page.body).to include('2 active players (1 dropped)')
  end

  it 'lists players' do
    expect(first('input[name="player[name]"]').value).to eq('Jack Player')
  end
end
