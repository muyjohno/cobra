RSpec.describe 'making advanced round edits' do
  let(:round) { create(:round, weight: 1.0) }

  before do
    sign_in round.tournament.user
    visit tournament_round_path(round.tournament, round)
    click_link 'Advanced'
  end

  it 'allows the user to edit round weighting' do
    fill_in 'SOS Weighting', with: 0.8
    click_button 'Save'

    expect(round.reload.weight).to eq(0.8)
  end
end
