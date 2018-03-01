RSpec.describe PairingStrategies::DoubleElim do
  let(:pairer) { described_class.new(round) }
  let(:round) { create(:round, number: 1, stage: stage, completed: true) }
  let(:stage) { tournament.current_stage }
  let(:tournament) { create(:tournament) }

  context 'top 8' do
    %w(alpha bravo charlie delta echo foxtrot golf hotel).each_with_index do |name, i|
      let!(name) { create(:player, tournament: tournament, name: name, seed: i+1) }
    end

    it 'creates correct pairings' do
      pairer.pair!

      round.reload

      aggregate_failures do
        expect(round.pairings.map{ |p| [p.player1, p.player2] }).to match_array(
          [[alpha, hotel], [bravo, golf], [charlie, foxtrot], [delta, echo]]
        )
        expect(round.pairings.first.table_number).to eq(1)
        expect(round.pairings.first.side).to eq(nil)
      end
    end

    context 'with some results' do
      let(:round3) { create(:round, number: 3, stage: stage) }
      let(:pairer) { described_class.new(round3) }

      before do
        create(:pairing, round: round, player1: alpha, player2: hotel, score1: 3, score2: 0, table_number: 1, side: :player1_is_corp)
        create(:pairing, round: round, player1: bravo, player2: golf, score1: 3, score2: 0, table_number: 2, side: :player1_is_corp)
        create(:pairing, round: round, player1: charlie, player2: foxtrot, score1: 3, score2: 0, table_number: 3, side: :player1_is_corp)
        create(:pairing, round: round, player1: delta, player2: echo, score1: 3, score2: 0, table_number: 4, side: :player1_is_corp)

        create(:pairing, round: round, player1: alpha, player2: delta, score1: 3, score2: 0, table_number: 5, side: :player1_is_corp)
        create(:pairing, round: round, player1: bravo, player2: charlie, score1: 3, score2: 0, table_number: 6, side: :player1_is_runner)
        create(:pairing, round: round, player1: hotel, player2: echo, score1: 0, score2: 3, table_number: 7, side: :player1_is_corp)
        create(:pairing, round: round, player1: golf, player2: foxtrot, score1: 0, score2: 3, table_number: 8, side: :player1_is_corp)
      end

      it 'creates correct pairings' do
        pairer.pair!

        round3.reload

        aggregate_failures do
          expect(round3.pairings.map{ |p| [p.player1, p.player2] }).to match_array(
            [[alpha, bravo], [charlie, echo], [foxtrot, delta]]
          )
          expect(round3.pairings.first.table_number).to eq(9)
          expect(round3.pairings.first.side.to_sym).to eq(:player1_is_runner)
        end
      end
    end
  end
end
