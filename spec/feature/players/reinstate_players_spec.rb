RSpec.describe 'reinstating players' do
  let(:tournament) { create(:tournament) }
  let!(:player) { create(:player, tournament: tournament, active: false) }

  before do
    sign_in tournament.user
    visit tournament_path(tournament)
  end

  it 'drops player' do
    expect do
      click_link 'Reinstate'
    end.not_to change(tournament.players, :count)

    expect(player.reload.active).to eq(true)
  end

  it 'redirects to players page' do
    click_link 'Reinstate'

    expect(current_path).to eq(tournament_path(tournament))
  end
end
