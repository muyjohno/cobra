RSpec.describe 'Re-pairing rounds' do
  let(:tournament) { create(:tournament) }
  let(:round) { create(:round, stage: tournament.current_stage) }
  let!(:player1) { create(:player, tournament: tournament) }
  let!(:player2) { create(:player, tournament: tournament) }

  before do
    sign_in round.tournament.user
    visit tournament_round_path(round.tournament, round)
  end

  it 're-pairs the round' do
    expect do
      click_link 'Re-pair'
    end.to change(Pairing, :count).by(1)

    expect(round.reload.unpaired_players).to eq([])
  end
end
