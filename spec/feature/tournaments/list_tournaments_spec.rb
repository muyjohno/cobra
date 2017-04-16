RSpec.describe 'listing tournaments' do
  before do
    create(:tournament) { create(:tournament, name: 'Some Tournament') }
    visit tournaments_path
  end

  it 'shows the tournaments' do
    expect(page).to have_content('Some Tournament')
  end
end
