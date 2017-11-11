RSpec.describe "list today's tournaments" do
  let!(:today) do
    create(:tournament, date: Date.today, name: 'TodayGNK', slug: 'TEST')
  end

  before do
    create(:tournament, date: Date.yesterday, name: 'YesterdayGNK', slug: '1234')
    create(:tournament, date: Date.tomorrow, name: 'TomorrowGNK', slug: '5678')

    visit root_path
  end

  it "only shows today's tournaments" do
    aggregate_failures do
      expect(page).not_to have_content('YesterdayGNK')
      expect(page).to have_content('TodayGNK')
      expect(page).not_to have_content('TomorrowGNK')
    end
  end

  it 'links to more tournaments' do
    click_link 'More tournaments'

    aggregate_failures do
      expect(page).to have_content('YesterdayGNK')
      expect(page).to have_content('TodayGNK')
      expect(page).to have_content('TomorrowGNK')
    end
  end

  describe 'shortcode form' do
    it 'redirects to tournament page' do
      fill_in :slug, with: 'TEST'
      click_button 'Go to tournament'

      expect(page.current_path).to eq(tournament_players_path(today))
    end

    it 'handles invalid shortcode' do
      fill_in :slug, with: 'NOSUCH'
      click_button 'Go to tournament'

      expect(page).to have_content("Couldn't find that tournament")
    end
  end
end
