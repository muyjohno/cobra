RSpec.describe 'showing a round' do
  let(:round) { create(:round) }

  before do
    visit tournament_round_path(round.tournament, round)
  end

  it 'is successful' do
    expect(page).to have_content("Round #{round.number}")
  end
end
