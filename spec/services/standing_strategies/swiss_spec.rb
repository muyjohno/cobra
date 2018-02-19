RSpec.describe StandingStrategies::Swiss do
  let(:tournament) { create(:tournament) }
  let(:stage) { tournament.current_stage }
  let(:strategy) { described_class.new(stage) }

  describe '#calculate!' do
    before do
      allow(SosCalculator).to receive(:calculate!)
    end

    it 'calls SosCalculator' do
      strategy.calculate!

      expect(SosCalculator).to have_received(:calculate!).with(stage)
    end
  end
end
