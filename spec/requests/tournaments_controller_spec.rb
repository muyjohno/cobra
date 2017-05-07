RSpec.describe TournamentsController do
  let(:tournament) { create(:tournament, name: 'My Tournament') }

  it 'responds with json file' do
    get save_json_tournament_path(tournament)

    expect(response.headers['Content-Disposition']).to eq(
      'attachment; filename="my tournament.json"'
    )
    expect(response.body).to eq(
      {
        name: 'My Tournament',
        cutToTop: 0,
        players: []
      }.to_json
    )
  end
end
