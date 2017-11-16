RSpec.describe 'listing tournaments' do
  before do
    create(:tournament, name: 'Some Tournament')
    create(:tournament, name: 'Private Tournament', private: true)
    visit tournaments_path
  end

  it 'shows the tournaments' do
    expect(page).to have_content('Some Tournament')
  end

  it 'does not show private tournaments' do
    expect(page).not_to have_content('Private Tournament')
  end
end
