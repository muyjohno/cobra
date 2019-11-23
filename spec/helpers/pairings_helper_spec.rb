RSpec.describe PairingsHelper do
  describe '#presets' do
    let(:tournament) { create(:tournament) }
    let(:stage) { tournament.current_stage }
    let(:pairing) { create(:pairing, stage: stage) }

    context 'for swiss' do
      it 'returns swiss defaults' do
        expect(helper.presets(pairing)).to eq(
          [
            { score1_corp: 3, score2_runner: 0, score1_runner: 3, score2_corp: 0, label: '6-0' },
            { score1_corp: 3, score2_runner: 0, score1_runner: 0, score2_corp: 3, label: '3-3 (C)' },
            { score1_corp: 0, score2_runner: 3, score1_runner: 3, score2_corp: 0, label: '3-3 (R)' },
            { score1_corp: 0, score2_runner: 3, score1_runner: 0, score2_corp: 3, label: '0-6' }
          ]
        )
      end
    end

    context 'for double elim' do
      let(:stage) { create(:stage, tournament: tournament, format: :double_elim) }

      context 'when side is unknown' do
        it 'returns double elim defaults' do
          expect(helper.presets(pairing)).to eq(
            [
              { score1: 3, score2: 0, score1_corp: 0, score2_runner: 0, score1_runner: 0, score2_corp: 0, label: '3-0' },
              { score1: 0, score2: 3, score1_corp: 0, score2_runner: 0, score1_runner: 0, score2_corp: 0, label: '0-3' }
            ]
          )
        end
      end

      context 'when player 1 is corp' do
        let(:pairing) { create(:pairing, stage: stage, side: :player1_is_corp) }

        it 'returns double elim defaults' do
          expect(helper.presets(pairing)).to eq(
            [
              { score1_corp: 3, score2_runner: 0, score1_runner: 0, score2_corp: 0, label: '3-0' },
              { score1_corp: 0, score2_runner: 3, score1_runner: 0, score2_corp: 0, label: '0-3' }
            ]
          )
        end
      end

      context 'when player 1 is runner' do
        let(:pairing) { create(:pairing, stage: stage, side: :player1_is_runner) }

        it 'returns double elim defaults' do
          expect(helper.presets(pairing)).to eq(
            [
              { score1_corp: 0, score2_runner: 0, score1_runner: 3, score2_corp: 0, label: '3-0' },
              { score1_corp: 0, score2_runner: 0, score1_runner: 0, score2_corp: 3, label: '0-3' }
            ]
          )
        end
      end
    end
  end

  describe '#side_options' do
    it 'returns correct options' do
      expect(helper.side_options).to eq([
        ["player1_is_corp", "player1_is_corp"],
        ["player1_is_runner", "player1_is_runner"]
      ])
    end
  end

  describe '#side_label_for' do
    let(:pairing) { create(:pairing, side: :player1_is_corp) }
    let(:undeclared) { create(:pairing, side: nil) }

    it 'returns side' do
      aggregate_failures do
        expect(helper.side_label_for(pairing, pairing.player1)).to eq("(Corp)")
        expect(helper.side_label_for(pairing, pairing.player2)).to eq("(Runner)")
      end
    end

    it 'returns nil for undeclared' do
      expect(helper.side_label_for(undeclared, undeclared.player1)).to eq(nil)
    end

    it 'returns nil for invalid player' do
      expect(helper.side_label_for(pairing, undeclared.player1)).to eq(nil)
    end
  end

  describe '#side_value' do
    let(:jack) { create(:player) }
    let(:jill) { create(:player) }
    let(:other) { create(:player) }
    let(:pairing) { create(:pairing, player1: jack, player2: jill) }

    it 'calculates side correctly' do
      aggregate_failures do
        expect(helper.side_value(other, :corp, pairing)).to eq(nil)
        expect(helper.side_value(jack, :corp, pairing)).to eq(:player1_is_corp)
        expect(helper.side_value(jill, :corp, pairing)).to eq(:player1_is_runner)
        expect(helper.side_value(jack, :runner, pairing)).to eq(:player1_is_runner)
        expect(helper.side_value(jill, :runner, pairing)).to eq(:player1_is_corp)
      end
    end
  end
end
