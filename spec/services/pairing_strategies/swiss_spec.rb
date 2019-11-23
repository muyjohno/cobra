RSpec.describe PairingStrategies::Swiss do
  let(:pairer) { described_class.new(round) }
  let(:round) { create(:round, number: 1, stage: stage) }
  let(:stage) { tournament.current_stage }
  let(:tournament) { create(:tournament) }
  let(:nil_player) { double('NilPlayer', id: nil, points: 0) }

  before do
    allow(NilPlayer).to receive(:new).and_return(nil_player)
  end

  context 'with four players' do
    %i(jack jill hansel gretel).each do |name|
      let!(name) do
        create(:player, name: name.to_s.humanize, tournament: tournament)
      end
    end

    it 'creates pairings' do
      pairer.pair!

      round.reload

      expect(round.pairings.count).to eq(2)
    end

    context 'with first round byes' do
      before do
        jack.update first_round_bye: true
        jill.update first_round_bye: true
      end

      it 'creates pairings' do
        pairer.pair!

        round.reload

        round.pairings.each do |pairing|
          expect(pairing.players).to match_array([jack, nil_player]) if pairing.players.include? jack
          expect(pairing.players).to match_array([jill, nil_player]) if pairing.players.include? jill
          expect(pairing.players).to match_array([hansel, gretel]) if pairing.players.include? hansel
        end
      end

      it 'gives byes highest table numbers' do
        pairer.pair!

        round.reload

        expect(round.pairings.bye.pluck(:table_number)).to match_array([2, 3])
      end

      context 'in second round' do
        let(:round2_pairer) { described_class.new(round2) }
        let(:round2) { create(:round, number: 2, stage: stage) }

        before do
          pairer.pair!
        end

        it 'does not create byes' do
          round2_pairer.pair!

          round2.reload

          expect(round2.pairings.count).to eq(2)
          expect(
            round2.pairings.map(&:players).flatten
          ).to contain_exactly(jack, jill, hansel, gretel)
        end
      end
    end

    context 'after some rounds' do
      let(:round1) { create(:round, number: 1, stage: stage) }
      let(:round) { create(:round, number: 2, stage: stage) }

      before do
        create(:pairing, player1: jack, player2: jill, score1: 6, score2: 0, round: round1)
        create(:pairing, player1: hansel, player2: gretel, score1: 4, score2: 1, round: round1)
      end

      it 'pairs based on points' do
        pairer.pair!

        round.reload

        round.pairings.each do |pairing|
          expect(pairing.players).to match_array([jack, hansel]) if pairing.players.include? jack
          expect(pairing.players).to match_array([jill, gretel]) if pairing.players.include? jill
        end
      end

      it 'avoids previous matchups' do
        create(:pairing, player1: jack, player2: hansel)

        pairer.pair!

        round.reload

        round.pairings.each do |pairing|
          expect(pairing.players).to match_array([jack, gretel]) if pairing.players.include? jack
          expect(pairing.players).to match_array([jill, hansel]) if pairing.players.include? jill
        end
      end
    end
  end

  context 'with three players' do
    %i(snap crackle pop).each do |name|
      let!(name) do
        create(:player, name: name.to_s.humanize, tournament: tournament)
      end
    end

    it 'creates bye' do
      pairer.pair!

      round.reload

      expect(
        round.pairings.map(&:players).flatten
      ).to contain_exactly(snap, crackle, pop, nil_player)
    end

    it 'gives bye highest table number' do
      pairer.pair!

      round.reload

      expect(round.pairings.bye.first.table_number).to eq(round.pairings.count)
    end

    it 'gives win against bye' do
      pairer.pair!

      round.reload.pairings.each do |pairing|
        expect(
          [pairing.score1, pairing.score2]
        ).to match_array(
          (pairing.players.include? nil_player) ? [0,6] : [nil, nil]
        )
      end
    end

    context 'after multiple rounds' do
      let(:round1) { create(:round, number: 1, stage: stage) }
      let(:round) { create(:round, number: 2, stage: stage) }

      before do
        create(:pairing, player1: snap, score1: 6, player2: crackle, score2: 3, round: round1)
        create(:pairing, player1: pop, player2: nil, score1: 1, score2: 0, round: round1)
      end

      it 'avoids previous byes' do
        pairer.pair!

        round.reload

        round.pairings.each do |pairing|
          expect(pairing.players).not_to match_array([pop, nil_player]) if pairing.players.include? pop
        end
      end

      it 'gives bye highest table number' do
        pairer.pair!

        round.reload

        expect(round.pairings.bye.first.table_number).to eq(round.pairings.count)
      end
    end

    context 'with drop' do
      before do
        pop.update active: false
      end

      it 'excludes dropped players' do
        pairer.pair!

        round.reload

        expect(
          round.pairings.map(&:players).flatten
        ).to contain_exactly(snap, crackle)
      end
    end
  end

  context 'with over 60 players' do
    let(:strategy) { double('PairingStrategies::BigSwiss') }

    before do
      create_list(:player, 61, tournament: tournament)
      allow(PairingStrategies::BigSwiss).to receive(:new).and_return(strategy)
      allow(strategy).to receive(:pair!).and_return([])
    end

    context 'first round' do
      it 'does not hand off to BigSwiss pairing strategy' do
        pairer.pair!

        expect(PairingStrategies::BigSwiss).not_to have_received(:new).with(stage)
        expect(strategy).not_to have_received(:pair!)
      end
    end

    context 'after a round' do
      let(:round) { create(:round, number: 2, stage: stage) }

      before do
        create(:round, number: 1, stage: stage)
      end

      it 'hands off to BigSwiss pairing strategy' do
        pairer.pair!

        expect(PairingStrategies::BigSwiss).to have_received(:new).with(stage)
        expect(strategy).to have_received(:pair!)
      end
    end
  end
end
