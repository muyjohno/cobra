RSpec.describe 'destroying pairings' do
  let(:player1) { create(:player, tournament: round.tournament) }
  let(:player2) { create(:player, tournament: round.tournament) }
  let(:round) { create(:round) }

  before do
    round.pairings.create(player1: player1, player2: player2)

    sign_in round.tournament.user
    visit tournament_round_path(round.tournament, round)
  end

  it 'deletes pairing' do
    expect do
      click_link 'Delete'
    end.to change(Pairing, :count).by(-1)

    expect(round.reload.unpaired_players).to eq([player1, player2])
  end
end
