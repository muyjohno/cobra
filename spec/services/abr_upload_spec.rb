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
    it 'responds with a code' do
      VCR.use_cassette :upload_to_abr do
        response = upload.upload!

        expect(response[:code]).to eq(301063)
      end
    end
  end

  describe '#data' do
    before do
      allow(tournament).to receive(:standings).and_return([
        Standing.new(jack),
        Standing.new(jill)
      ])
    end

    it 'returns hash of data' do
      expect(upload.data).to eq({
        name: 'Some Tournament',
        cutToTop: 0,
        players: [
          { corpIdentity: 'ETF', runnerIdentity: 'Noise', rank: 1, id: jack.id, name: jack.name },
          { corpIdentity: 'PE', runnerIdentity: 'Gabe', rank: 2, id: jill.id, name: jill.name }
        ]
      })
    end
  end
end
