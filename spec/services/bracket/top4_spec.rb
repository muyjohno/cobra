RSpec.describe Bracket::Top4 do
  let(:tournament) { create(:tournament) }
  let(:bracket) { described_class.new(tournament) }
  %w(alpha bravo charlie delta).each_with_index do |name, i|
    let!(name) { create(:player, tournament: tournament, name: name, seed: i+1) }
  end

  describe '#pair' do
    context 'round 1' do
      let(:pair) { bracket.pair(1) }

      it 'returns correct pairings' do
        expect(pair).to match_array([
          { table_number: 1, player1: alpha, player2: delta },
          { table_number: 2, player1: bravo, player2: charlie }
        ])
      end
    end

    context 'round 2' do
      let(:pair) { bracket.pair(2) }

      before do
        r1 = create(:round, tournament: tournament)
        report r1, 1, alpha, 3, delta, 0
        report r1, 2, bravo, 3, charlie, 0
      end

      it 'returns correct pairings' do
        expect(pair).to match_array([
          { table_number: 3, player1: alpha, player2: bravo },
          { table_number: 4, player1: delta, player2: charlie }
        ])
      end
    end

    context 'round 3' do
      let(:pair) { bracket.pair(3) }

      before do
        r1 = create(:round, tournament: tournament)
        report r1, 1, alpha, 3, delta, 0
        report r1, 2, bravo, 3, charlie, 0

        r2 = create(:round, tournament: tournament)
        report r2, 3, alpha, 3, bravo, 0
        report r2, 4, delta, 0, charlie, 3
      end

      it 'returns correct pairings' do
        expect(pair).to match_array([
          { table_number: 5, player1: bravo, player2: charlie }
        ])
      end
    end

    context 'round 4' do
      let(:pair) { bracket.pair(4) }

      before do
        r1 = create(:round, tournament: tournament)
        report r1, 1, alpha, 3, delta, 0
        report r1, 2, bravo, 3, charlie, 0

        r2 = create(:round, tournament: tournament)
        report r2, 3, alpha, 3, bravo, 0
        report r2, 4, delta, 0, charlie, 3

        report r2, 5, bravo, 3, charlie, 0
      end

      it 'returns correct pairings' do
        expect(pair).to match_array([
          { table_number: 6, player1: alpha, player2: bravo }
        ])
      end
    end

    context 'round 5' do
      let(:pair) { bracket.pair(5) }

      before do
        r1 = create(:round, tournament: tournament)
        report r1, 1, alpha, 3, delta, 0
        report r1, 2, bravo, 3, charlie, 0

        r2 = create(:round, tournament: tournament)
        report r2, 3, alpha, 3, bravo, 0
        report r2, 4, delta, 0, charlie, 3

        report r2, 5, bravo, 3, charlie, 0
        report r2, 6, alpha, 0, bravo, 3
      end

      it 'returns correct pairings' do
        expect(pair).to match_array([
          { table_number: 7, player1: bravo, player2: alpha }
        ])
      end
    end
  end

  describe '#standings' do
    before do
      r1 = create(:round, tournament: tournament)
      report r1, 1, alpha, 3, delta, 0
      report r1, 2, bravo, 3, charlie, 0

      r2 = create(:round, tournament: tournament)
      report r2, 3, alpha, 3, bravo, 0
      report r2, 4, delta, 0, charlie, 3

      report r2, 5, bravo, 3, charlie, 0
      report r2, 6, alpha, 0, bravo, 3
      report r2, 7, bravo, 3, alpha, 0
    end

    it 'returns correct standings' do
      expect(bracket.standings.map(&:player)).to eq(
        [bravo, alpha, charlie, delta]
      )
    end
  end
end
