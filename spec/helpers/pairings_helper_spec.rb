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
      expect(helper.side_label_for(pairing, pairing.player1)).to eq("(C)")
      expect(helper.side_label_for(pairing, pairing.player2)).to eq("(R)")
    end

    it 'returns nil for undeclared' do
      expect(helper.side_label_for(undeclared, undeclared.player1)).to eq(nil)
    end

    it 'returns nil for invalid player' do
      expect(helper.side_label_for(pairing, undeclared.player1)).to eq(nil)
    end
  end
end
