RSpec.describe 'uploading tournament' do
  let(:tournament) { create(:tournament) }
  let(:uploader) { instance_double('AbrUpload') }

  before do
    allow(AbrUpload).to receive(:new).and_return(uploader)
    allow(uploader).to receive(:upload!).and_return({ code: '937521' })

    visit edit_tournament_path(tournament)
  end

  it 'stores code' do
    click_link 'Upload to Always Be Running'

    expect(page).to have_content('937521')
    expect(tournament.reload.abr_code).to eq('937521')
  end
end
