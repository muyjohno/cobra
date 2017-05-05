RSpec.describe AbrUpload do
  let(:tournament) { create(:tournament) }
  let(:jack) { create(:player) }
  let(:jill) { create(:player) }
  let(:round) { create(:round, tournament: tournament) }

  before do
    round.pairings << create(:pairing, player1: jack, player2: jill)
  end

  it 'responds with a code' do
    VCR.use_cassette :upload_to_abr do
      response = described_class.upload!(tournament)

      expect(response[:code]).to eq(301063)
    end
  end
end
