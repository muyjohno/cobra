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

  describe '#sos' do
    before do
      other = create(:player)
      # player played two games, including against opponent 'other'
      create(:pairing, player1: player, player2: other, score2: 2)
      create(:pairing, player1: player, score2: 3)
      # other played one other eligible game
      create(:pairing, player2: other, score2: 5)
      # and a bye, which is not eligible
      create(:pairing, player1: other, player2: nil, score1: 6)
    end

    it 'calculates from other opponents points' do
      expect(standing.sos).to eq(10)
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
        score1: 4
      )
    end

    it 'sorts correctly by score' do
      expect([other_standing, standing].sort).to eq([standing, other_standing])
    end

    it 'sorts correctly by sos' do
      expect([tied_standing, standing].sort).to eq([standing, tied_standing])
    end
  end
end
