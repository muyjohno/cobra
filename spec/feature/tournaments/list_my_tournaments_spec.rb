RSpec.describe 'listing my tournaments' do
  let(:me) { create(:user) }
  before do
    create(:tournament, name: 'Some Tournament', user: me)
    create(:tournament, name: 'Private Tournament', private: true, user: me)
    create(:tournament, name: 'Not My Tournament')
  end

  context 'as user' do
    before do
      sign_in me
      visit my_tournaments_path
    end

    it 'shows my public tournaments' do
      expect(page).to have_content('Some Tournament')
    end

    it 'shows my private tournaments' do
      expect(page).to have_content('Private Tournament')
    end

    it 'does not show other user\'s tournaments' do
      expect(page).not_to have_content('Not My Tournament')
    end
  end

  context 'as guest' do
    it 'redirects away' do
      visit my_tournaments_path

      expect(current_path).to eq(root_path)
    end
  end
end
