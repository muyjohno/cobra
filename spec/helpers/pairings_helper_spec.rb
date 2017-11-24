RSpec.describe PairingsHelper do
  describe '#presets' do
    context 'for swiss' do
      let(:tournament) { create(:tournament, stage: :swiss) }

      it 'returns swiss defaults' do
        expect(helper.presets(tournament)).to eq(
          [[6, 0], [3, 3], [0, 6]]
        )
      end
    end

    context 'for double elim' do
      let(:tournament) { create(:tournament, stage: :double_elim) }

      it 'returns double elim defaults' do
        expect(helper.presets(tournament)).to eq(
          [[3, 0], [0, 3]]
        )
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
