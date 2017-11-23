RSpec.describe 'dropping players' do
  let(:tournament) { create(:tournament) }
  let!(:player) { create(:player, tournament: tournament, active: true) }

  before do
    sign_in tournament.user
    visit tournament_path(tournament)
  end

  it 'drops player' do
    expect do
      click_link 'Drop'
    end.not_to change(tournament.players, :count)

    expect(player.reload.active).to eq(false)
  end

  it 'redirects to players page' do
    click_link 'Drop'

    expect(current_path).to eq(tournament_path(tournament))
  end
end
