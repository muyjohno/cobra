RSpec.describe Round do
  let(:round) { create(:round) }
  let(:pairer) { double('Pairer', pair!: true) }

  describe '#pair!' do
    before do
      allow(Pairer).to receive(:new).and_return(pairer)
    end

    it 'invokes Pairer' do
      round.pair!

      expect(Pairer).to have_received(:new).with(round)
      expect(pairer).to have_received(:pair!)
    end
  end
end
