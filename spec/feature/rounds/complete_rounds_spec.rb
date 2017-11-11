RSpec.describe 'Completing rounds' do
  let(:round) { create(:round, completed: false) }
  let(:player1) { create(:player, tournament: round.tournament) }
  let(:player2) { create(:player, tournament: round.tournament) }
  let!(:pairing) do
    create(:pairing, player1: player1, player2: player2, round: round)
  end

  before do
    sign_in round.tournament.user
    visit tournament_rounds_path(round.tournament)
  end

  it 'completes the round' do
    click_link 'Complete'

    expect(round.reload.completed?).to eq(true)
  end
end
