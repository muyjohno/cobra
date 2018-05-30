RSpec.describe 'importing a tournament from TOME' do
  let(:tournament) { create(:tournament) }
  let(:importer) { double('Import::Tome', apply: true) }

  it 'declines access to unauthorised users' do
    visit import_from_tome_tournament_path(tournament)

    expect(page).to have_content("Sorry, you can't do that")
  end

  context 'as tournament owner' do
    before do
      sign_in tournament.user
      visit edit_tournament_path(tournament)
      click_link 'Import from TOME'

      fill_in :tome_import_tome_import, with: 'Some data'

      allow(Import::Tome).to receive(:new).and_return(importer)
    end

    it 'applies update to tournament' do
      click_button 'Import'

      expect(Import::Tome).to have_received(:new)
      expect(importer).to have_received(:apply).with(tournament)
    end
  end
end
