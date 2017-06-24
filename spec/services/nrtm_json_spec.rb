RSpec.describe NrtmJson do
  let(:tournament) { create(:tournament, name: 'Some Tournament') }
  let(:jack) { create(:player, corp_identity: 'ETF', runner_identity: 'Noise') }
  let(:jill) { create(:player, corp_identity: 'PE', runner_identity: 'Gabe') }
  let(:round) { create(:round, tournament: tournament) }

  let(:json) { described_class.new(tournament) }

  before do
    round.pairings << create(:pairing, player1: jack, player2: jill)
  end

  describe '#data' do
    before do
      allow(tournament).to receive(:standings).and_return([
        Standing.new(jack),
        Standing.new(jill)
      ])
    end

    it 'returns hash of data' do
      expect(json.data).to eq({
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
