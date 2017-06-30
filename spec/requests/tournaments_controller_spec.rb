RSpec.describe TournamentsController do
  let(:tournament) { create(:tournament, name: 'My Tournament') }

  describe '#save_json' do
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

  describe '#cut' do
    let(:cut) { create(:tournament) }
    before do
      allow(Tournament).to receive(:find).with(tournament.id.to_s).and_return(tournament)
      allow(tournament).to receive(:cut_to!).and_return(cut)
    end

    it 'cuts tournament' do
      sign_in tournament.user
      post cut_tournament_path(tournament, number: 8)

      expect(tournament).to have_received(:cut_to!).with(:double_elim, 8)
    end
  end
end
