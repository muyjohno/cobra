RSpec.describe Tournament do
  let(:tournament) { create(:tournament, player_count: 4) }

  describe '#pair_new_round!' do
    it 'creates new round with pairings' do
      expect do
        round = tournament.pair_new_round!

        expect(
          round.pairings.map(&:players).flatten
        ).to match_array(tournament.players)
      end.to change(tournament.rounds, :count).by(1)
    end

    describe 'round numbers' do
      it 'creates first with number 1' do
        expect(tournament.pair_new_round!.number).to eq(1)
      end

      it 'adds to previous highest' do
        create(:round, tournament: tournament, number: 4)

        expect(tournament.pair_new_round!.number).to eq(5)
      end
    end
  end

  describe '#standings' do
    let(:standings) { instance_double('Standings') }

    before do
      allow(Standings).to receive(:new).and_return(standings)
    end

    it 'returns standings object' do
      expect(tournament.standings).to eq(standings)
      expect(Standings).to have_received(:new).with(tournament)
    end
  end

  describe '#pairing_sorter' do
    context 'random' do
      let(:tournament) { create(:tournament, pairing_sort: :random) }

      it 'returns correct class' do
        expect(tournament.pairing_sorter).to eq(PairingSorters::Random)
      end
    end

    context 'ranked' do
      let(:tournament) { create(:tournament, pairing_sort: :ranked) }

      it 'returns correct class' do
        expect(tournament.pairing_sorter).to eq(PairingSorters::Ranked)
      end
    end
  end

  describe '#corp_counts' do
    before do
      tournament.players = [
        create(:player, corp_identity: 'Something'),
        create(:player, corp_identity: 'Something'),
        create(:player, corp_identity: 'Something else')
      ]
    end

    it 'returns counts' do
      expect(tournament.corp_counts).to eq([
        ['Something', 2],
        ['Something else', 1]
      ])
    end
  end

  describe '#runner_counts' do
    before do
      tournament.players = [
        create(:player, runner_identity: 'Some runner')
      ]
    end

    it 'returns counts' do
      expect(tournament.runner_counts).to eq([
        ['Some runner', 1]
      ])
    end
  end

  describe '#cut_to!' do
    let(:cut) do
      tournament.cut_to! :double_elim, 4
    end

    before { tournament }

    it 'creates elim tournament' do
      expect do
        cut
      end.to change(Tournament, :count).by(1)
    end

    it 'assigns tournament to previous tournament\'s user' do
      expect(cut.user).to eq(tournament.user)
    end

    it 'clones players' do
      aggregate_failures do
        expect(cut.players.map(&:name)).to eq(tournament.top(4).map(&:name))
        expect(cut.players.map(&:corp_identity)).to eq(tournament.top(4).map(&:corp_identity))
        expect(cut.players.map(&:runner_identity)).to eq(tournament.top(4).map(&:runner_identity))
        expect(cut.players.map(&:seed)).to eq([1,2,3,4])
      end
    end
  end

  describe '#previous' do
    let!(:child) { create(:tournament, previous: tournament) }

    it 'establishes association' do
      expect(child.previous).to eq(tournament)
      expect(tournament.next).to eq(child)
    end
  end
end
