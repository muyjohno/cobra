RSpec.describe Bracket::Top16 do
  let(:tournament) { create(:tournament) }
  let(:stage) { tournament.stages.create(format: :double_elim) }
  let(:bracket) { described_class.new(stage) }
  %w(alex_b seamus tom rob dien mike mark laurie tim alex_w andy_w ian_g iain_f chris andy_l jonny).each_with_index do |name, i|
    let!(name) do
      create(:player, tournament: tournament, name: name, seed: i+1).tap do |p|
        create(:registration, player: p, stage: stage, seed: i+1)
      end
    end
  end

  describe '#pair' do
    context 'round 1' do
      let(:pair) { bracket.pair(1) }

      it 'returns correct pairings' do
        expect(pair).to match_array([
          { table_number: 1, player1: alex_b, player2: jonny },
          { table_number: 2, player1: laurie, player2: tim },
          { table_number: 3, player1: dien, player2: ian_g },
          { table_number: 4, player1: rob, player2: iain_f },
          { table_number: 5, player1: tom, player2: chris },
          { table_number: 6, player1: mike, player2: andy_w },
          { table_number: 7, player1: mark, player2: alex_w },
          { table_number: 8, player1: seamus, player2: andy_l }
        ])
      end
    end

    context 'round 2' do
      let(:pair) { bracket.pair(2) }

      before do
        r1 = create(:round, stage: stage, completed: true)
        report r1, 1, alex_b, 3, jonny, 0
        report r1, 2, laurie, 3, tim, 0
        report r1, 3, dien, 3, ian_g, 0
        report r1, 4, rob, 3, iain_f, 0
        report r1, 5, tom, 0, chris, 3
        report r1, 6, mike, 3, andy_w, 0
        report r1, 7, mark, 3, alex_w, 0
        report r1, 8, seamus, 3, andy_l, 0
      end

      it 'returns correct pairings' do
        expect(pair).to match_array([
          { table_number: 9, player1: jonny, player2: tim },
          { table_number: 10, player1: ian_g, player2: iain_f },
          { table_number: 11, player1: tom, player2: andy_w },
          { table_number: 12, player1: alex_w, player2: andy_l },
          { table_number: 13, player1: alex_b, player2: laurie },
          { table_number: 14, player1: dien, player2: rob },
          { table_number: 15, player1: chris, player2: mike },
          { table_number: 16, player1: mark, player2: seamus }
        ])
      end
    end

    context 'round 3' do
      let(:pair) { bracket.pair(3) }

      before do
        r1 = create(:round, stage: stage, completed: true)
        report r1, 1, alex_b, 3, jonny, 0
        report r1, 2, laurie, 3, tim, 0
        report r1, 3, dien, 3, ian_g, 0
        report r1, 4, rob, 3, iain_f, 0
        report r1, 5, tom, 0, chris, 3
        report r1, 6, mike, 3, andy_w, 0
        report r1, 7, mark, 3, alex_w, 0
        report r1, 8, seamus, 3, andy_l, 0

        r2 = create(:round, stage: stage, completed: true)
        report r1, 9, jonny, 0, tim, 3
        report r1, 10, ian_g, 3, iain_f, 0
        report r1, 11, tom, 3, andy_w, 0
        report r1, 12, alex_w, 0, andy_l, 3
        report r1, 13, alex_b, 3, laurie, 0
        report r1, 14, dien, 3, rob, 0
        report r1, 15, chris, 3, mike, 0
        report r1, 16, mark, 0, seamus, 3
      end

      it 'returns correct pairings' do
        expect(pair).to match_array([
          { table_number: 17, player1: mark, player2: tim },
          { table_number: 18, player1: mike, player2: ian_g },
          { table_number: 19, player1: rob, player2: tom },
          { table_number: 20, player1: laurie, player2: andy_l },
          { table_number: 21, player1: alex_b, player2: dien },
          { table_number: 22, player1: chris, player2: seamus }
        ])
      end
    end

    context 'round 4' do
      let(:pair) { bracket.pair(4) }

      before do
        r1 = create(:round, stage: stage, completed: true)
        report r1, 1, alex_b, 3, jonny, 0
        report r1, 2, laurie, 3, tim, 0
        report r1, 3, dien, 3, ian_g, 0
        report r1, 4, rob, 3, iain_f, 0
        report r1, 5, tom, 0, chris, 3
        report r1, 6, mike, 3, andy_w, 0
        report r1, 7, mark, 3, alex_w, 0
        report r1, 8, seamus, 3, andy_l, 0

        r2 = create(:round, stage: stage, completed: true)
        report r1, 9, jonny, 0, tim, 3
        report r1, 10, ian_g, 3, iain_f, 0
        report r1, 11, tom, 3, andy_w, 0
        report r1, 12, alex_w, 0, andy_l, 3
        report r1, 13, alex_b, 3, laurie, 0
        report r1, 14, dien, 3, rob, 0
        report r1, 15, chris, 3, mike, 0
        report r1, 16, mark, 0, seamus, 3

        r3 = create(:round, stage: stage, completed: true)
        report r3, 17, mark, 0, tim, 3
        report r3, 18, mike, 0, ian_g, 3
        report r3, 19, rob, 3, tom, 0
        report r3, 20, laurie, 3, andy_l, 0
        report r3, 21, alex_b, 3, dien, 0
        report r3, 22, chris, 3, seamus, 0
      end

      it 'returns correct pairings' do
        expect(pair).to match_array([
          { table_number: 23, player1: tim, player2: ian_g },
          { table_number: 24, player1: rob, player2: laurie },
          { table_number: 27, player1: alex_b, player2: chris }
        ])
      end
    end

    context 'round 5' do
      let(:pair) { bracket.pair(5) }

      before do
        r1 = create(:round, stage: stage, completed: true)
        report r1, 1, alex_b, 3, jonny, 0
        report r1, 2, laurie, 3, tim, 0
        report r1, 3, dien, 3, ian_g, 0
        report r1, 4, rob, 3, iain_f, 0
        report r1, 5, tom, 0, chris, 3
        report r1, 6, mike, 3, andy_w, 0
        report r1, 7, mark, 3, alex_w, 0
        report r1, 8, seamus, 3, andy_l, 0

        r2 = create(:round, stage: stage, completed: true)
        report r1, 9, jonny, 0, tim, 3
        report r1, 10, ian_g, 3, iain_f, 0
        report r1, 11, tom, 3, andy_w, 0
        report r1, 12, alex_w, 0, andy_l, 3
        report r1, 13, alex_b, 3, laurie, 0
        report r1, 14, dien, 3, rob, 0
        report r1, 15, chris, 3, mike, 0
        report r1, 16, mark, 0, seamus, 3

        r3 = create(:round, stage: stage, completed: true)
        report r3, 17, mark, 0, tim, 3
        report r3, 18, mike, 0, ian_g, 3
        report r3, 19, rob, 3, tom, 0
        report r3, 20, laurie, 3, andy_l, 0
        report r3, 21, alex_b, 3, dien, 0
        report r3, 22, chris, 3, seamus, 0

        r4 = create(:round, stage: stage, completed: true)
        report r4, 23, tim, 3, ian_g, 0
        report r4, 24, rob, 0, laurie, 3
        report r4, 27, alex_b, 0, chris, 3
      end

      it 'returns correct pairings' do
        expect(pair).to match_array([
          { table_number: 25, player1: dien, player2: tim },
          { table_number: 26, player1: laurie, player2: seamus }
        ])
      end
    end

    context 'round 6' do
      let(:pair) { bracket.pair(6) }

      before do
        r1 = create(:round, stage: stage, completed: true)
        report r1, 1, alex_b, 3, jonny, 0
        report r1, 2, laurie, 3, tim, 0
        report r1, 3, dien, 3, ian_g, 0
        report r1, 4, rob, 3, iain_f, 0
        report r1, 5, tom, 0, chris, 3
        report r1, 6, mike, 3, andy_w, 0
        report r1, 7, mark, 3, alex_w, 0
        report r1, 8, seamus, 3, andy_l, 0

        r2 = create(:round, stage: stage, completed: true)
        report r1, 9, jonny, 0, tim, 3
        report r1, 10, ian_g, 3, iain_f, 0
        report r1, 11, tom, 3, andy_w, 0
        report r1, 12, alex_w, 0, andy_l, 3
        report r1, 13, alex_b, 3, laurie, 0
        report r1, 14, dien, 3, rob, 0
        report r1, 15, chris, 3, mike, 0
        report r1, 16, mark, 0, seamus, 3

        r3 = create(:round, stage: stage, completed: true)
        report r3, 17, mark, 0, tim, 3
        report r3, 18, mike, 0, ian_g, 3
        report r3, 19, rob, 3, tom, 0
        report r3, 20, laurie, 3, andy_l, 0
        report r3, 21, alex_b, 3, dien, 0
        report r3, 22, chris, 3, seamus, 0

        r4 = create(:round, stage: stage, completed: true)
        report r4, 23, tim, 3, ian_g, 0
        report r4, 24, rob, 0, laurie, 3
        report r4, 27, alex_b, 0, chris, 3

        report r4, 25, dien, 0, tim, 3
        report r4, 26, laurie, 0, seamus, 3
      end

      it 'returns correct pairings' do
        expect(pair).to match_array([
          { table_number: 28, player1: tim, player2: seamus }
        ])
      end
    end

    context 'round 7' do
      let(:pair) { bracket.pair(7) }

      before do
        r1 = create(:round, stage: stage, completed: true)
        report r1, 1, alex_b, 3, jonny, 0
        report r1, 2, laurie, 3, tim, 0
        report r1, 3, dien, 3, ian_g, 0
        report r1, 4, rob, 3, iain_f, 0
        report r1, 5, tom, 0, chris, 3
        report r1, 6, mike, 3, andy_w, 0
        report r1, 7, mark, 3, alex_w, 0
        report r1, 8, seamus, 3, andy_l, 0

        r2 = create(:round, stage: stage, completed: true)
        report r1, 9, jonny, 0, tim, 3
        report r1, 10, ian_g, 3, iain_f, 0
        report r1, 11, tom, 3, andy_w, 0
        report r1, 12, alex_w, 0, andy_l, 3
        report r1, 13, alex_b, 3, laurie, 0
        report r1, 14, dien, 3, rob, 0
        report r1, 15, chris, 3, mike, 0
        report r1, 16, mark, 0, seamus, 3

        r3 = create(:round, stage: stage, completed: true)
        report r3, 17, mark, 0, tim, 3
        report r3, 18, mike, 0, ian_g, 3
        report r3, 19, rob, 3, tom, 0
        report r3, 20, laurie, 3, andy_l, 0
        report r3, 21, alex_b, 3, dien, 0
        report r3, 22, chris, 3, seamus, 0

        r4 = create(:round, stage: stage, completed: true)
        report r4, 23, tim, 3, ian_g, 0
        report r4, 24, rob, 0, laurie, 3
        report r4, 27, alex_b, 0, chris, 3

        report r4, 25, dien, 0, tim, 3
        report r4, 26, laurie, 0, seamus, 3
        report r4, 28, tim, 3, seamus, 0
      end

      it 'returns correct pairings' do
        expect(pair).to match_array([
          { table_number: 29, player1: alex_b, player2: tim }
        ])
      end
    end

    context 'round 8' do
      let(:pair) { bracket.pair(8) }

      before do
        r1 = create(:round, stage: stage, completed: true)
        report r1, 1, alex_b, 3, jonny, 0
        report r1, 2, laurie, 3, tim, 0
        report r1, 3, dien, 3, ian_g, 0
        report r1, 4, rob, 3, iain_f, 0
        report r1, 5, tom, 0, chris, 3
        report r1, 6, mike, 3, andy_w, 0
        report r1, 7, mark, 3, alex_w, 0
        report r1, 8, seamus, 3, andy_l, 0

        r2 = create(:round, stage: stage, completed: true)
        report r1, 9, jonny, 0, tim, 3
        report r1, 10, ian_g, 3, iain_f, 0
        report r1, 11, tom, 3, andy_w, 0
        report r1, 12, alex_w, 0, andy_l, 3
        report r1, 13, alex_b, 3, laurie, 0
        report r1, 14, dien, 3, rob, 0
        report r1, 15, chris, 3, mike, 0
        report r1, 16, mark, 0, seamus, 3

        r3 = create(:round, stage: stage, completed: true)
        report r3, 17, mark, 0, tim, 3
        report r3, 18, mike, 0, ian_g, 3
        report r3, 19, rob, 3, tom, 0
        report r3, 20, laurie, 3, andy_l, 0
        report r3, 21, alex_b, 3, dien, 0
        report r3, 22, chris, 3, seamus, 0

        r4 = create(:round, stage: stage, completed: true)
        report r4, 23, tim, 3, ian_g, 0
        report r4, 24, rob, 0, laurie, 3
        report r4, 27, alex_b, 0, chris, 3

        report r4, 25, dien, 0, tim, 3
        report r4, 26, laurie, 0, seamus, 3
        report r4, 28, tim, 3, seamus, 0
        report r4, 29, alex_b, 0, tim, 3
      end

      it 'returns correct pairings' do
        expect(pair).to match_array([
          { table_number: 30, player1: chris, player2: tim }
        ])
      end
    end

    context 'round 8' do
      let(:pair) { bracket.pair(9) }

      before do
        r1 = create(:round, stage: stage, completed: true)
        report r1, 1, alex_b, 3, jonny, 0
        report r1, 2, laurie, 3, tim, 0
        report r1, 3, dien, 3, ian_g, 0
        report r1, 4, rob, 3, iain_f, 0
        report r1, 5, tom, 0, chris, 3
        report r1, 6, mike, 3, andy_w, 0
        report r1, 7, mark, 3, alex_w, 0
        report r1, 8, seamus, 3, andy_l, 0

        r2 = create(:round, stage: stage, completed: true)
        report r1, 9, jonny, 0, tim, 3
        report r1, 10, ian_g, 3, iain_f, 0
        report r1, 11, tom, 3, andy_w, 0
        report r1, 12, alex_w, 0, andy_l, 3
        report r1, 13, alex_b, 3, laurie, 0
        report r1, 14, dien, 3, rob, 0
        report r1, 15, chris, 3, mike, 0
        report r1, 16, mark, 0, seamus, 3

        r3 = create(:round, stage: stage, completed: true)
        report r3, 17, mark, 0, tim, 3
        report r3, 18, mike, 0, ian_g, 3
        report r3, 19, rob, 3, tom, 0
        report r3, 20, laurie, 3, andy_l, 0
        report r3, 21, alex_b, 3, dien, 0
        report r3, 22, chris, 3, seamus, 0

        r4 = create(:round, stage: stage, completed: true)
        report r4, 23, tim, 3, ian_g, 0
        report r4, 24, rob, 0, laurie, 3
        report r4, 27, alex_b, 0, chris, 3

        report r4, 25, dien, 0, tim, 3
        report r4, 26, laurie, 0, seamus, 3
        report r4, 28, tim, 3, seamus, 0
        report r4, 29, alex_b, 0, tim, 3
        report r4, 30, chris, 0, tim, 3
      end

      it 'returns correct pairings' do
        expect(pair).to match_array([
          { table_number: 31, player1: tim, player2: chris }
        ])
      end
    end
  end

  describe '#standings' do
    context 'complete bracket' do
      before do
        r1 = create(:round, stage: stage, completed: true)
        report r1, 1, alex_b, 3, jonny, 0
        report r1, 2, laurie, 3, tim, 0
        report r1, 3, dien, 3, ian_g, 0
        report r1, 4, rob, 3, iain_f, 0
        report r1, 5, tom, 0, chris, 3
        report r1, 6, mike, 3, andy_w, 0
        report r1, 7, mark, 3, alex_w, 0
        report r1, 8, seamus, 3, andy_l, 0

        r2 = create(:round, stage: stage, completed: true)
        report r1, 9, jonny, 0, tim, 3
        report r1, 10, ian_g, 3, iain_f, 0
        report r1, 11, tom, 3, andy_w, 0
        report r1, 12, alex_w, 0, andy_l, 3
        report r1, 13, alex_b, 3, laurie, 0
        report r1, 14, dien, 3, rob, 0
        report r1, 15, chris, 3, mike, 0
        report r1, 16, mark, 0, seamus, 3

        r3 = create(:round, stage: stage, completed: true)
        report r3, 17, mark, 0, tim, 3
        report r3, 18, mike, 0, ian_g, 3
        report r3, 19, rob, 3, tom, 0
        report r3, 20, laurie, 3, andy_l, 0
        report r3, 21, alex_b, 3, dien, 0
        report r3, 22, chris, 3, seamus, 0

        r4 = create(:round, stage: stage, completed: true)
        report r4, 23, tim, 3, ian_g, 0
        report r4, 24, rob, 0, laurie, 3
        report r4, 27, alex_b, 0, chris, 3

        report r4, 25, dien, 0, tim, 3
        report r4, 26, laurie, 0, seamus, 3
        report r4, 28, tim, 3, seamus, 0
        report r4, 29, alex_b, 0, tim, 3
        report r4, 30, chris, 0, tim, 3
        report r4, 31, tim, 3, chris, 0
      end

      it 'returns correct standings' do
        expect(bracket.standings.map(&:player)).to eq(
          [tim, chris, alex_b, seamus, dien, laurie, rob, ian_g, tom, mike, mark, andy_l, alex_w, andy_w, iain_f, jonny]
        )
      end
    end

    context 'second final still to play' do
      before do
        r1 = create(:round, stage: stage, completed: true)
        report r1, 1, alex_b, 3, jonny, 0
        report r1, 2, laurie, 3, tim, 0
        report r1, 3, dien, 3, ian_g, 0
        report r1, 4, rob, 3, iain_f, 0
        report r1, 5, tom, 0, chris, 3
        report r1, 6, mike, 3, andy_w, 0
        report r1, 7, mark, 3, alex_w, 0
        report r1, 8, seamus, 3, andy_l, 0

        r2 = create(:round, stage: stage, completed: true)
        report r1, 9, jonny, 0, tim, 3
        report r1, 10, ian_g, 3, iain_f, 0
        report r1, 11, tom, 3, andy_w, 0
        report r1, 12, alex_w, 0, andy_l, 3
        report r1, 13, alex_b, 3, laurie, 0
        report r1, 14, dien, 3, rob, 0
        report r1, 15, chris, 3, mike, 0
        report r1, 16, mark, 0, seamus, 3

        r3 = create(:round, stage: stage, completed: true)
        report r3, 17, mark, 0, tim, 3
        report r3, 18, mike, 0, ian_g, 3
        report r3, 19, rob, 3, tom, 0
        report r3, 20, laurie, 3, andy_l, 0
        report r3, 21, alex_b, 3, dien, 0
        report r3, 22, chris, 3, seamus, 0

        r4 = create(:round, stage: stage, completed: true)
        report r4, 23, tim, 3, ian_g, 0
        report r4, 24, rob, 0, laurie, 3
        report r4, 27, alex_b, 0, chris, 3

        report r4, 25, dien, 0, tim, 3
        report r4, 26, laurie, 0, seamus, 3
        report r4, 28, tim, 3, seamus, 0
        report r4, 29, alex_b, 0, tim, 3
      end

      let(:r5) { create(:round, stage: stage, completed: true) }

      context 'second final required' do
        before do
          report r5, 30, chris, 0, tim, 3
        end

        it 'returns ambiguous top two' do
          expect(bracket.standings.map(&:player)).to eq(
            [nil, nil, alex_b, seamus, dien, laurie, rob, ian_g, tom, mike, mark, andy_l, alex_w, andy_w, iain_f, jonny]
          )
        end
      end

      context 'second final not required' do
        before do
          report r5, 30, chris, 3, tim, 0
        end

        it 'returns top two' do
          expect(bracket.standings.map(&:player)).to eq(
            [chris, tim, alex_b, seamus, dien, laurie, rob, ian_g, tom, mike, mark, andy_l, alex_w, andy_w, iain_f, jonny]
          )
        end
      end
    end

    context 'multiple rounds still to play' do
      before do
        r1 = create(:round, stage: stage, completed: true)
        report r1, 1, alex_b, 3, jonny, 0
        report r1, 2, laurie, 3, tim, 0
        report r1, 3, dien, 3, ian_g, 0
        report r1, 4, rob, 3, iain_f, 0
        report r1, 5, tom, 0, chris, 3
        report r1, 6, mike, 3, andy_w, 0
        report r1, 7, mark, 3, alex_w, 0
        report r1, 8, seamus, 3, andy_l, 0

        r2 = create(:round, stage: stage, completed: true)
        report r1, 9, jonny, 0, tim, 3
        report r1, 10, ian_g, 3, iain_f, 0
        report r1, 11, tom, 3, andy_w, 0
        report r1, 12, alex_w, 0, andy_l, 3
        report r1, 13, alex_b, 3, laurie, 0
        report r1, 14, dien, 3, rob, 0
        report r1, 15, chris, 3, mike, 0
        report r1, 16, mark, 0, seamus, 3

        r3 = create(:round, stage: stage, completed: true)
        report r3, 17, mark, 0, tim, 3
        report r3, 18, mike, 0, ian_g, 3
        report r3, 19, rob, 3, tom, 0
        report r3, 20, laurie, 3, andy_l, 0
        report r3, 21, alex_b, 3, dien, 0
        report r3, 22, chris, 3, seamus, 0

        r4 = create(:round, stage: stage, completed: true)
        report r4, 23, tim, 3, ian_g, 0
        report r4, 24, rob, 0, laurie, 3
        report r4, 27, alex_b, 0, chris, 3
      end

      it 'returns fixed finishes' do
        expect(bracket.standings.map(&:player)).to eq(
          [nil, nil, nil, nil, nil, nil, rob, ian_g, tom, mike, mark, andy_l, alex_w, andy_w, iain_f, jonny]
        )
      end
    end
  end
end
