RSpec.describe Standings do
  let(:tournament) { create(:tournament) }
  let(:stage) { tournament.current_stage }
  let!(:jack) { create(:player, tournament: tournament) }
  let!(:jill) { create(:player, tournament: tournament) }
  let!(:hansel) { create(:player, tournament: tournament) }
  let!(:gretel) { create(:player, tournament: tournament) }
  let(:round1) { create(:round, stage: stage, completed: true) }
  let(:round2) { create(:round, stage: stage, completed: true) }
  let(:standings) { described_class.new(stage) }

  before do
    round1.pairings << create(:pairing, player1: jack, player2: jill, score1: 6, score2: 0)
    round1.pairings << create(:pairing, player1: hansel, player2: gretel, score1: 3, score2: 3)
    round2.pairings << create(:pairing, player1: jack, player2: hansel, score1: 0, score2: 6)
    round2.pairings << create(:pairing, player1: gretel, player2: jill, score1: 6, score2: 0)
  end

  describe '#players' do
    it 'ranks players' do
      expect(standings.players.map(&:player)).to eq([hansel, gretel, jack, jill])
    end

    describe 'double elim bracket', :pending do
      let(:cut) { tournament.cut_to! :double_elim, 4 }
      let(:standings) { described_class.new(cut) }

      let(:elim1) { create(:round, tournament: cut) }
      let(:elim2) { create(:round, tournament: cut) }
      let(:elim3) { create(:round, tournament: cut) }
      let(:elim4) { create(:round, tournament: cut) }
      let(:elim5) { create(:round, tournament: cut) }

      before do
        elim1.pairings << create(:pairing, player1: hansel, player2: jill, table_number: 1, score1: 3, score2: 0)
        elim1.pairings << create(:pairing, player1: gretel, player2: jack, table_number: 2, score1: 3, score2: 0)

        elim2.pairings << create(:pairing, player1: hansel, player2: gretel, table_number: 3, score1: 0, score2: 3)
        elim2.pairings << create(:pairing, player1: jill, player2: jack, table_number: 4, score1: 3, score2: 0)

        elim3.pairings << create(:pairing, player1: hansel, player2: jill, table_number: 5, score1: 0, score2: 3)

        elim4.pairings << create(:pairing, player1: gretel, player2: jill, table_number: 6, score1: 0, score2: 3)

        elim5.pairings << create(:pairing, player1: jill, player2: gretel, table_number: 7, score1: 0, score2: 3)
      end

      it 'ranks players' do
        expect(standings.players.map(&:player)).to eq([gretel, jill, hansel, jack])
      end
    end
  end

  describe '#top' do
    it 'returns top players' do
      expect(standings.top(2)).to eq([hansel, gretel])
    end

    context 'with dropped player' do
      before do
        gretel.drop!
      end

      it 'returns top players' do
        expect(standings.top(2)).to eq([hansel, jack])
      end
    end
  end
end
