RSpec.describe 'viewing a tournament' do
  let(:tournament) { create(:tournament) }
  let!(:player) { create(:player, name: 'Jack Player', tournament: tournament) }

  before do
    visit tournament_path(tournament)
  end

  it 'displays player names' do
    expect(page).to have_content('Jack Player')
  end

  it 'displays tournament status' do
    expect(page).to have_content('This tournament is: REGISTERING')
  end
end
