RSpec.describe 'listing players' do
  let(:tournament) { create(:tournament) }

  before do
    tournament.players << create(:player, name: 'Jack Player')

    visit tournament_players_path(tournament)
  end

  it 'lists players' do
    expect(first('input[name="player[name]"]').value).to eq('Jack Player')
  end
end
