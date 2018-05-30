RSpec.describe TournamentsController do
  let(:tournament) { create(:tournament, name: 'My Tournament') }

  describe '#save_json' do
    before do
      allow(NrtmJson).to receive(:new).with(tournament).and_return(
        double(:json, data: { some: :data })
      )
    end

    it 'responds with json file' do
      get save_json_tournament_path(tournament)

      expect(response.headers['Content-Disposition']).to eq(
        'attachment; filename="my tournament.json"'
      )
      expect(response.body).to eq("{\"some\":\"data\"}")
    end
  end

  describe '#cut' do
    let(:cut) { create(:stage, tournament: tournament) }

    before do
      allow(Tournament).to receive(:find)
        .with(tournament.to_param)
        .and_return(tournament)
      allow(tournament).to receive(:cut_to!).and_return(cut)
    end

    it 'cuts tournament' do
      sign_in tournament.user
      post cut_tournament_path(tournament), params: { number: 8 }

      expect(tournament).to have_received(:cut_to!).with(:double_elim, 8)
    end
  end

  describe '#apply_import_from_tome' do
    let(:importer) { double( apply: true) }

    before do
      allow(Import::Tome).to receive(:new).and_return(importer)
    end

    it 'prevents unauthorised access' do
      post apply_import_from_tome_tournament_path(tournament),
        params: { tome_import: { tome_import: 'SOMEJSON' }}

      expect(response).to redirect_to(root_path)
    end

    it 'applies import to the tournament' do
      sign_in tournament.user

      post apply_import_from_tome_tournament_path(tournament),
        params: { tome_import: { tome_import: 'SOMEJSON' }}

      expect(Import::Tome).to have_received(:new).with('SOMEJSON')
      expect(importer).to have_received(:apply).with(tournament)
    end

    it 'redirects to tournament page' do
      sign_in tournament.user

      post apply_import_from_tome_tournament_path(tournament),
        params: { tome_import: { tome_import: 'SOMEJSON' }}

      expect(response).to redirect_to(tournament_players_path(tournament))
    end
  end
end
