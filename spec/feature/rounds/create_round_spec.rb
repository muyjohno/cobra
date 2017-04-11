RSpec.describe 'creating a round' do
  let(:tournament) { create(:tournament, status: :waiting, player_count: 4) }

  before do
    visit tournament_path(tournament)
  end

  it 'changes the tournament state to playing' do
    click_button 'Pair new round'

    expect(tournament.reload.playing?).to be true
  end

  it 'redirects to rounds page' do
    click_button 'Pair new round'

    expect(current_path).to eq tournament_rounds_path(tournament)
  end
end
