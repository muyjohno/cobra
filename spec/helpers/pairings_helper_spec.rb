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
end
