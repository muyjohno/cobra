RSpec.describe 'starting a tournament' do
  let(:tournament) { create(:tournament) }

  before do
    visit tournament_path(tournament)
  end

  it 'changes the tournament state to waiting' do
    click_button 'Start Tournament'

    expect(tournament.reload.waiting?).to be true
  end

  it 'redirects to tournament page' do
    click_button 'Start Tournament'

    expect(current_path).to eq tournament_path(tournament)
  end
end
