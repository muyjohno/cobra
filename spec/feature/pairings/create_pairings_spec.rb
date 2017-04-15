RSpec.describe 'creating pairings' do
  let(:round) { create(:round) }
  let!(:player1) { create(:player, tournament: round.tournament) }
  let!(:player2) { create(:player, tournament: round.tournament) }

  before do
    visit tournament_round_path(round.tournament, round)

    fill_in 'pairing[table_number]', with: '23'
    select player1.name, from: 'pairing[player1_id]'
    select player2.name, from: 'pairing[player2_id]'
  end

  it 'allows you to create a new pairing' do
    expect do
      click_button 'Create'
    end.to change(Pairing, :count).by(1)

    expect(round.reload.unpaired_players).to eq([])
  end

  it 'creates pairing correctly' do
    click_button 'Create'

    expect(Pairing.last.table_number).to eq(23)
  end

  it 'handles byes' do
    select '(Bye)', from: 'pairing[player2_id]'

    expect do
      click_button 'Create'
    end.to change(Pairing, :count).by(1)

    expect(round.reload.unpaired_players).to eq([player2])
  end
end
