RSpec.describe 'creating a round' do
  let(:tournament) { create(:tournament, player_count: 4) }

  before do
    sign_in tournament.user
    visit tournament_rounds_path(tournament)
  end

  it 'redirects to rounds page' do
    click_link 'Pair new round'

    expect(current_path).to eq tournament_rounds_path(tournament)
  end
end
