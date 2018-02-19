RSpec.describe 'viewing standings' do
  let(:tournament) { create(:tournament) }

  before do
    tournament.players << create(
      :player,
      name: 'Jack',
      corp_identity: 'Some Corp',
      runner_identity: 'Some Runner'
    )
    tournament.players << create(
      :player,
      name: 'Jill',
      corp_identity: 'Another Corp',
      runner_identity: 'Another Runner'
    )

    sign_in tournament.user
  end

  context 'with no rounds completed' do
    before do
      visit standings_tournament_players_path(tournament)
    end

    it 'does not display identities' do
      expect(page).not_to have_content('Some Corp')
    end
  end

  context 'with a round completed' do
    before do
      create(:round, tournament: tournament, number: 1, completed: true)
      visit standings_tournament_players_path(tournament)
    end

    it 'displays corp and runner' do
      aggregate_failures do
        expect(page).to have_content('Some Corp Some Runner')
        expect(page).to have_content('Another Corp Another Runner')
      end
    end
  end
end
