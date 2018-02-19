RSpec.describe NrtmJson, :pending do
  let(:to) { create(:user, nrdb_id: 123, nrdb_username: 'username') }
  let(:tournament) { create(:tournament, name: 'Some Tournament', user: to, slug: 'SLUG', date: '2017-01-01') }
  let(:jack) { create(:player, name: 'Jack', corp_identity: 'ETF', runner_identity: 'Noise', id: 1001) }
  let(:jill) { create(:player, name: 'Jill', corp_identity: 'PE', runner_identity: 'Gabe', id: 1002) }
  let(:hansel) { create(:player, name: 'Hansel', corp_identity: 'MN', runner_identity: 'Kate', id: 1003) }
  let(:gretel) { create(:player, name: 'Gretel', corp_identity: 'BABW', runner_identity: 'Whizzard', id: 1004) }
  let(:snap) { create(:player, name: 'Snap', corp_identity: 'ST', runner_identity: 'Invalid', id: 1005) }
  let(:crackle) { create(:player, name: 'Crackle', corp_identity: 'RP', runner_identity: 'Andromeda', id: 1006) }
  let(:pop) { create(:player, name: 'Pop', corp_identity: 'TWIY', runner_identity: 'Reina', id: 1007) }
  let(:round) { create(:round, tournament: tournament) }

  let(:json) { described_class.new(tournament) }

  before do
    round.pairings << create(:pairing, player1: jack, player2: jill, table_number: 1, score1: 6, score2: 0)
    round.pairings << create(:pairing, player1: hansel, player2: gretel, table_number: 2, score1: 5, score2: 1)
    round.pairings << create(:pairing, player1: snap, player2: crackle, table_number: 3, score1: 4, score2: 2)
    round.pairings << create(:pairing, player1: pop, player2: nil, table_number: 4, score1: 3, score2: 0)

    %w(ETF Noise PE Gabe MN Kate BABW Whizzard ST RP Andromeda TWIY Reina).each do |id|
      create(:identity, name: id)
    end
  end

  describe '#data' do
    before do
      allow(StandingStrategies::Swiss).to receive(:new)
        .with(tournament)
        .and_return(
          double(
            :standings,
            calculate!: [
              Standing.new(jack, points: 6, sos: 1.6, extended_sos: 2.6),
              Standing.new(hansel, points: 5, sos: 1.5, extended_sos: 2.5),
              Standing.new(snap, points: 4, sos: 1.4, extended_sos: 2.4),
              Standing.new(pop, points: 3, sos: 1.3, extended_sos: 2.3),
              Standing.new(crackle, points: 2, sos: 1.2, extended_sos: 2.2),
              Standing.new(gretel, points: 1, sos: 1.1, extended_sos: 2.1),
              Standing.new(jill, points: 0, sos: 1.0, extended_sos: 2.0)
            ]
          )
        )
    end

    it 'returns hash of data' do
      expect(json.data.with_indifferent_access).to eq(
        JSON.parse(File.read('spec/fixtures/nrtm_json_swiss.json'))
      )
    end

    context 'with elimination bracket' do
      let(:cut) { tournament.cut_to! :double_elim, 4 }
      let(:json) { described_class.new(cut) }

      before do
        cut.update(date: '2017-01-02', slug: 'CUTT')

        r1 = create(:round, tournament: cut)
        report r1, 1, jack.next, 3, pop.next, 0, :player1_is_corp
        report r1, 2, hansel.next, 3, snap.next, 0, :player1_is_corp

        r2 = create(:round, tournament: cut)
        report r2, 3, jack.next, 3, hansel.next, 0, :player1_is_corp
        report r2, 4, pop.next, 0, snap.next, 3, :player1_is_runner

        report r2, 5, hansel.next, 3, snap.next, 0, :player1_is_runner
        report r2, 6, jack.next, 0, hansel.next, 3, :player1_is_corp
        report r2, 7, hansel.next, 3, jack.next, 0, :player1_is_runner
      end

      it 'returns hash of data' do
        expect(JSON.parse(json.data.to_json)).to eq(
          JSON.parse(File.read('spec/fixtures/nrtm_json_cut.json'))
        )
      end
    end
  end
end
