RSpec.describe 'destroying tournaments' do
  let(:tournament) { create(:tournament) }
  let(:round) { create(:round, stage: tournament.current_stage) }

  before do
    create(:player, tournament: tournament)
    create(:player, tournament: tournament)

    round.pair!

    sign_in tournament.user
    visit root_path
  end

  it 'destroys tournament' do
    expect do
      click_link 'Delete'
    end.to change(Tournament, :count).by(-1)
  end

  it 'destroys associated players' do
    expect do
      click_link 'Delete'
    end.to change(Player, :count).by(-2)
  end

  it 'destroys associated rounds' do
    expect do
      click_link 'Delete'
    end.to change(Round, :count).by(-1)
  end

  it 'destroys associated pairings' do
    expect do
      click_link 'Delete'
    end.to change(Pairing, :count).by(-1)
  end
end
