RSpec.describe StandingStrategies::DoubleElim do
  let(:stage) { tournament.current_stage }
  let(:strategy) { described_class.new(stage) }

  describe '#calculate!' do
    context 'with four players' do
      let(:tournament) { create(:tournament, player_count: 4) }
      let(:bracket) { instance_double('Bracket::Top4', standings: nil) }

      before do
        allow(Bracket::Top4).to receive(:new).and_return(bracket)
      end

      it 'calls Bracket::Top4' do
        strategy.calculate!

        expect(Bracket::Top4).to have_received(:new).with(stage)
        expect(bracket).to have_received(:standings)
      end
    end

    context 'with eight players' do
      let(:tournament) { create(:tournament, player_count: 8) }
      let(:bracket) { instance_double('Bracket::Top8', standings: nil) }

      before do
        allow(Bracket::Top8).to receive(:new).and_return(bracket)
      end

      it 'calls Bracket::Top8' do
        strategy.calculate!

        expect(Bracket::Top8).to have_received(:new).with(stage)
        expect(bracket).to have_received(:standings)
      end
    end
  end
end
