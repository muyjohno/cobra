RSpec.describe Standing do
  let(:player) { create(:player) }
  let(:standing) { Standing.new(player) }

  describe '#corp_identity' do
    before { player.corp_identity = 'RP' }

    it 'delegates to player' do
      expect(standing.corp_identity).to eq('RP')
    end
  end

  describe '#runner_identity' do
    before { player.runner_identity = 'Reina Roja' }

    it 'delegates to player' do
      expect(standing.runner_identity).to eq('Reina Roja')
    end
  end

  describe 'sorting' do
    let(:other) { create(:player) }

    it 'sorts by points' do
      expect(
        Standing.new(player, points: 3) <=> Standing.new(other, points: 0)
      ).to eq(-1)
      expect(
        Standing.new(player, points: 2) <=> Standing.new(other, points: 2)
      ).to eq(0)
      expect(
        Standing.new(player, points: 1) <=> Standing.new(other, points: 5)
      ).to eq(1)
    end

    it 'sorts by sos' do
      expect(
        Standing.new(player,
          points: 3,
          sos: 2.0
        ) <=> Standing.new(other,
          points: 3,
          sos: 1.8
        )
      ).to eq(-1)
      expect(
        Standing.new(player,
          points: 3,
          sos: 2.0
        ) <=> Standing.new(other,
          points: 3,
          sos: 2.0
        )
      ).to eq(0)
      expect(
        Standing.new(player,
          points: 3,
          sos: 1.4
        ) <=> Standing.new(other,
          points: 3,
          sos: 1.8
        )
      ).to eq(1)
    end

    it 'sorts by extended sos' do
      expect(
        Standing.new(player,
          points: 3,
          sos: 2.0,
          extended_sos: 3.3
        ) <=> Standing.new(other,
          points: 3,
          sos: 2.0,
          extended_sos: 1.3
        )
      ).to eq(-1)
      expect(
        Standing.new(player,
          points: 3,
          sos: 2.0,
          extended_sos: 3.3
        ) <=> Standing.new(other,
          points: 3,
          sos: 2.0,
          extended_sos: 3.3
        )
      ).to eq(0)
      expect(
        Standing.new(player,
          points: 3,
          sos: 2.0,
          extended_sos: 0.3
        ) <=> Standing.new(other,
          points: 3,
          sos: 2.0,
          extended_sos: 1.3
        )
      ).to eq(1)
    end
  end
end
