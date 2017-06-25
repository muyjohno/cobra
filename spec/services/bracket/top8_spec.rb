RSpec.describe Bracket::Top8 do
  let(:tournament) { create(:tournament) }
  let(:bracket) { described_class.new(tournament) }
  %w(alpha bravo charlie delta echo foxtrot golf hotel).each_with_index do |name, i|
    let!(name) { create(:player, tournament: tournament, name: name, seed: i+1) }
  end

  def report(round, number, p1, score1, p2, score2)
    create(:pairing,
      round: round,
      player1: p1,
      player2: p2,
      score1: score1,
      score2: score2,
      table_number: number
    )
  end

  describe '#pair' do
    context 'round 1' do
      let(:pair) { bracket.pair(1) }

      it 'returns correct pairings' do
        expect(pair).to match_array([
          { table_number: 1, player1: alpha, player2: hotel },
          { table_number: 2, player1: delta, player2: echo },
          { table_number: 3, player1: bravo, player2: golf },
          { table_number: 4, player1: charlie, player2: foxtrot }
        ])
      end
    end

    context 'round 2' do
      let(:pair) { bracket.pair(2) }

      before do
        r1 = create(:round, tournament: tournament)
        report r1, 1, alpha, 3, hotel, 0
        report r1, 2, delta, 3, echo, 0
        report r1, 3, bravo, 3, golf, 0
        report r1, 4, charlie, 3, foxtrot, 0
      end

      it 'returns correct pairings' do
        expect(pair).to match_array([
          { table_number: 5, player1: alpha, player2: delta },
          { table_number: 6, player1: bravo, player2: charlie },
          { table_number: 7, player1: hotel, player2: echo },
          { table_number: 8, player1: golf, player2: foxtrot }
        ])
      end
    end

    context 'round 3' do
      let(:pair) { bracket.pair(3) }

      before do
        r1 = create(:round, tournament: tournament)
        report r1, 1, alpha, 3, hotel, 0
        report r1, 2, delta, 3, echo, 0
        report r1, 3, bravo, 3, golf, 0
        report r1, 4, charlie, 3, foxtrot, 0

        r2 = create(:round, tournament: tournament)
        report r2, 5, alpha, 3, delta, 0
        report r2, 6, bravo, 3, charlie, 0
        report r2, 7, hotel, 0, echo, 3
        report r2, 8, golf, 0, foxtrot, 3
      end

      it 'returns correct pairings' do
        expect(pair).to match_array([
          { table_number: 9, player1: alpha, player2: bravo },
          { table_number: 10, player1: charlie, player2: echo },
          { table_number: 11, player1: foxtrot, player2: delta }
        ])
      end
    end

    context 'round 4' do
      let(:pair) { bracket.pair(4) }

      before do
        r1 = create(:round, tournament: tournament)
        report r1, 1, alpha, 3, hotel, 0
        report r1, 2, delta, 3, echo, 0
        report r1, 3, bravo, 3, golf, 0
        report r1, 4, charlie, 3, foxtrot, 0

        r2 = create(:round, tournament: tournament)
        report r2, 5, alpha, 3, delta, 0
        report r2, 6, bravo, 3, charlie, 0
        report r2, 7, hotel, 0, echo, 3
        report r2, 8, golf, 0, foxtrot, 3

        r3 = create(:round, tournament: tournament)
        report r3, 9, alpha, 3, bravo, 0
        report r3, 10, charlie, 3, echo, 0
        report r3, 11, foxtrot, 0, delta, 3
      end

      it 'returns correct pairings' do
        expect(pair).to match_array([
          { table_number: 12, player1: charlie, player2: delta }
        ])
      end
    end

    context 'round 5' do
      let(:pair) { bracket.pair(5) }

      before do
        r1 = create(:round, tournament: tournament)
        report r1, 1, alpha, 3, hotel, 0
        report r1, 2, delta, 3, echo, 0
        report r1, 3, bravo, 3, golf, 0
        report r1, 4, charlie, 3, foxtrot, 0

        r2 = create(:round, tournament: tournament)
        report r2, 5, alpha, 3, delta, 0
        report r2, 6, bravo, 3, charlie, 0
        report r2, 7, hotel, 0, echo, 3
        report r2, 8, golf, 0, foxtrot, 3

        r3 = create(:round, tournament: tournament)
        report r3, 9, alpha, 3, bravo, 0
        report r3, 10, charlie, 3, echo, 0
        report r3, 11, foxtrot, 0, delta, 3

        report r3, 12, charlie, 3, delta, 0
      end

      it 'returns correct pairings' do
        expect(pair).to match_array([
          { table_number: 13, player1: bravo, player2: charlie }
        ])
      end
    end

    context 'round 6' do
      let(:pair) { bracket.pair(6) }

      before do
        r1 = create(:round, tournament: tournament)
        report r1, 1, alpha, 3, hotel, 0
        report r1, 2, delta, 3, echo, 0
        report r1, 3, bravo, 3, golf, 0
        report r1, 4, charlie, 3, foxtrot, 0

        r2 = create(:round, tournament: tournament)
        report r2, 5, alpha, 3, delta, 0
        report r2, 6, bravo, 3, charlie, 0
        report r2, 7, hotel, 0, echo, 3
        report r2, 8, golf, 0, foxtrot, 3

        r3 = create(:round, tournament: tournament)
        report r3, 9, alpha, 3, bravo, 0
        report r3, 10, charlie, 3, echo, 0
        report r3, 11, foxtrot, 0, delta, 3

        report r3, 12, charlie, 3, delta, 0
        report r3, 13, bravo, 3, charlie, 0
      end

      it 'returns correct pairings' do
        expect(pair).to match_array([
          { table_number: 14, player1: alpha, player2: bravo }
        ])
      end
    end

    context 'round 7' do
      let(:pair) { bracket.pair(7) }

      before do
        r1 = create(:round, tournament: tournament)
        report r1, 1, alpha, 3, hotel, 0
        report r1, 2, delta, 3, echo, 0
        report r1, 3, bravo, 3, golf, 0
        report r1, 4, charlie, 3, foxtrot, 0

        r2 = create(:round, tournament: tournament)
        report r2, 5, alpha, 3, delta, 0
        report r2, 6, bravo, 3, charlie, 0
        report r2, 7, hotel, 0, echo, 3
        report r2, 8, golf, 0, foxtrot, 3

        r3 = create(:round, tournament: tournament)
        report r3, 9, alpha, 3, bravo, 0
        report r3, 10, charlie, 3, echo, 0
        report r3, 11, foxtrot, 0, delta, 3

        report r3, 12, charlie, 3, delta, 0
        report r3, 13, bravo, 3, charlie, 0
        report r3, 14, alpha, 0, bravo, 3
      end

      it 'returns correct pairings' do
        expect(pair).to match_array([
          { table_number: 15, player1: bravo, player2: alpha }
        ])
      end
    end
  end
end
