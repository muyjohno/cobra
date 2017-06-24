RSpec.describe AbrUpload do
  let(:upload) { described_class.new(tournament) }
  let(:tournament) { create(:tournament, name: 'Some Tournament') }
  let(:jack) { create(:player, corp_identity: 'ETF', runner_identity: 'Noise') }
  let(:jill) { create(:player, corp_identity: 'PE', runner_identity: 'Gabe') }
  let(:round) { create(:round, tournament: tournament) }

  before do
    round.pairings << create(:pairing, player1: jack, player2: jill)
  end

  describe '.upload!' do
    before do
      allow(described_class).to receive(:new).with(tournament).and_return(upload)
      allow(upload).to receive(:upload!)
    end

    it 'calls new instance' do
      described_class.upload!(tournament)

      expect(upload).to have_received(:upload!)
    end
  end

  describe '#upload!' do
    let(:json) { NrtmJson.new(tournament) }

    before do
      allow(NrtmJson).to receive(:new).with(tournament).and_return(json)
      allow(json).to receive(:data).and_return({ some: :data })
    end

    it 'responds with a code' do
      VCR.use_cassette :upload_to_abr do
        response = upload.upload!

        expect(response[:code]).to eq(301063)
      end
    end

    it 'delegates to json class' do
      VCR.use_cassette :upload_to_abr do
        upload.upload!

        expect(json).to have_received(:data)
      end
    end
  end
end
