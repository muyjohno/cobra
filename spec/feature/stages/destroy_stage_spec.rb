RSpec.describe 'destroying a stage' do
  let(:tournament) { create(:tournament) }

  before do
    sign_in tournament.user
    visit tournament_rounds_path(tournament)
  end

  it 'allows stages to be destroyed' do
    expect do
      click_on class: 'btn-danger'
    end.to change(Stage, :count).by(-1)
  end
end
