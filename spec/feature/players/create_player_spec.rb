RSpec.describe 'creating a player' do
  let(:tournament) { create(:tournament) }

  context 'signed in' do
    before do
      sign_in tournament.user
      visit tournament_path(tournament)
      fill_in :player_name, with: 'Jack'
      fill_in :player_corp_identity, with: 'Haas-Bioroid: Engineering the Future'
      fill_in :player_runner_identity, with: 'Noise'
      check :player_first_round_bye
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
        expect(subject.corp_identity).to eq('Haas-Bioroid: Engineering the Future')
        expect(subject.runner_identity).to eq('Noise')
        expect(subject.first_round_bye).to eq(true)
        expect(subject.tournament).to eq(tournament)
      end
    end

    it 'redirects to players page' do
      click_button 'Create'

      expect(page.current_path).to eq(tournament_path(tournament))
    end
  end
end
