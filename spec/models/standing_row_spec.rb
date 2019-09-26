RSpec.describe StandingRow do
  let(:player) { create(:player) }
  let(:row) { create(:standing_row, player: player) }

  describe '#corp_identity' do
    let!(:identity) { create(:identity, name: 'RP') }

    before { player.corp_identity = 'RP' }

    it 'delegates to player' do
      expect(row.corp_identity).to eq(identity)
    end
  end

  describe '#runner_identity' do
    let!(:identity) { create(:identity, name: 'Reina Roja') }

    before { player.runner_identity = 'Reina Roja' }

    it 'delegates to player' do
      expect(row.runner_identity).to eq(identity)
    end
  end
end
