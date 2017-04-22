RSpec.describe Standing do
  let(:player) { create(:player) }
  let(:standing) { Standing.new(player) }

  describe '#points' do
    before do
      create(:pairing, player1: player, score1: 5)
      create(:pairing, player1: player, score1: 2, player2: nil)
    end

    it 'returns total of all points from pairings including byes' do
      expect(standing.points).to eq(7)
    end
  end

  describe 'sos' do
    before do
      other = create(:player)
      # player played two games, including against opponent 'other'
      create(:pairing, player1: player, player2: other, score1: 3, score2: 2)
      create(:pairing, player1: player, score1: 1, score2: 3)
      # other played one other eligible game
      create(:pairing, player2: other, score1: 0, score2: 5)
    end

    describe '#sos' do
      it 'calculates sos' do
        expect(standing.sos).to eq(3.25)
      end
    end

    describe '#extended_sos' do
      it 'calculates extended sos' do
        expect(standing.extended_sos).to eq(1.5)
      end
    end
  end

  describe '#<=>' do
    let(:other_standing) { Standing.new(create(:player)) }
    let(:tied_standing) { Standing.new(create(:player))}

    before do
      create(:pairing,
        player1: player,
        player2: other_standing.player,
        score1: 4,
        score2: 1
      )
      create(:pairing,
        player1: tied_standing.player,
        score1: 4,
        score2: 0
      )
    end

    it 'sorts correctly by score' do
      expect([other_standing, standing].sort).to eq([standing, other_standing])
    end

    it 'sorts correctly by sos' do
      expect([tied_standing, standing].sort).to eq([standing, tied_standing])
    end

    it 'sorts correctly by extended sos' do
      s1 = Standing.new(create(:player))
      s2 = Standing.new(create(:player))
      allow(s1.calculator).to receive(:extended_sos).and_return(0.1)
      allow(s2.calculator).to receive(:extended_sos).and_return(0.2)

      expect([s1, s2].sort).to eq([s2, s1])
    end
  end
end
