RSpec.describe 'destroying pairings' do
  let(:tournament) { create(:tournament) }
  let(:player1) { create(:player, tournament: tournament) }
  let(:player2) { create(:player, tournament: tournament) }
  let(:round) { create(:round, tournament: tournament) }

  before do
    round.pairings.create(player1: player1, player2: player2)

    visit tournament_round_path(tournament, round)
  end

  it 'deletes pairing' do
    expect do
      click_link 'Delete'
    end.to change(Pairing, :count).by(-1)

    expect(round.reload.unpaired_players).to eq([player1, player2])
  end
end
