RSpec.describe Pairer do
  let(:tournament) { create(:tournament) }
  let(:stage) { tournament.current_stage }
  let(:round) { create(:round, number: 1, stage: stage) }
  let(:pairer) { described_class.new(round) }

  %i(jack jill hansel gretel).each do |name|
    let!(name) do
      create(:player, name: name.to_s.humanize, tournament: tournament)
    end
  end

  describe '#pair!' do
    context 'swiss' do
      let(:strategy) { double('PairingStrategies::Swiss') }

      it 'delegates to swiss strategy' do
        allow(PairingStrategies::Swiss).to receive(:new).and_return(strategy)
        allow(strategy).to receive(:pair!)

        pairer.pair!

        expect(strategy).to have_received(:pair!)
      end

      it 'applies table numbers' do
        pairer.pair!
        round.reload

        expect(round.pairings.map(&:table_number).flatten).to eq([1, 2])
      end
    end

    context 'double elim' do
      let(:stage) { create(:stage, format: :double_elim) }
      let(:strategy) { double('PairingStrategies::DoubleElim') }

      before do
        stage.players << jack
        stage.players << jill
        stage.players << hansel
        stage.players << gretel
      end

      it 'delegates to double_elim strategy' do
        allow(PairingStrategies::DoubleElim).to receive(:new).and_return(strategy)
        allow(strategy).to receive(:pair!)

        pairer.pair!

        expect(strategy).to have_received(:pair!)
      end
    end
  end
end
