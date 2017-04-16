RSpec.describe 'Re-pairing rounds' do
  let(:round) { create(:round) }
  let!(:player1) { create(:player, tournament: round.tournament) }
  let!(:player2) { create(:player, tournament: round.tournament) }

  before do
    visit tournament_round_path(round.tournament, round)
  end

  it 're-pairs the round' do
    expect do
      click_link 'Re-pair'
    end.to change(Pairing, :count).by(1)

    expect(round.reload.unpaired_players).to eq([])
  end
end
