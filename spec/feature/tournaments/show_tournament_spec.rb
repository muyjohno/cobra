RSpec.describe 'viewing a tournament' do
  let(:tournament) { create(:tournament) }
  let!(:player) { create(:player, name: 'Jack Player', tournament: tournament) }

  before do
    visit tournament_path(tournament)
  end

  it 'displays tournament status' do
    expect(page).to have_content('This tournament is: registering')
  end
end
