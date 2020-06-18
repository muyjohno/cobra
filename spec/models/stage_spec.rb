RSpec.describe Stage do
  let(:tournament) { create(:tournament) }
  let(:stage) { create(:stage, tournament: tournament) }

  describe '#pair_new_round!' do
    it 'creates new round with pairings' do
      expect do
        round = stage.pair_new_round!

        expect(
          round.pairings.map(&:players).flatten
        ).to match_array(tournament.players)
      end.to change(stage.rounds, :count).by(1)
    end

    describe 'round numbers' do
      it 'creates first with number 1' do
        expect(stage.pair_new_round!.number).to eq(1)
      end

      it 'adds to previous highest' do
        round = create(:round, stage: stage, number: 4)

        expect(stage.pair_new_round!.number).to eq(5)
      end
    end
  end

  describe '#standings' do
    let(:standings) { instance_double('Standings') }

    before do
      allow(Standings).to receive(:new).and_return(standings)
    end

    it 'returns standings object' do
      expect(stage.standings).to eq(standings)
      expect(Standings).to have_received(:new).with(stage)
    end
  end

  describe '#players' do
    let(:player1) { create(:player, tournament: tournament, skip_registration: true) }
    let(:player2) { create(:player, tournament: tournament, skip_registration: true) }

    before do
      stage.players << player1
    end

    it 'only returns players from this stage' do
      aggregate_failures do
        expect(stage.players).to include(player1)
        expect(stage.players).not_to include(player2)
      end
    end
  end

  describe '#eligible_pairings' do
    let(:round1) { create(:round, stage: stage, completed: true) }
    let(:round2) { create(:round, stage: stage, completed: false) }
    let!(:pairing1) { create(:pairing, round: round1) }
    let!(:pairing2) { create(:pairing, round: round2) }

    it 'only returns pairings from completed rounds' do
      expect(stage.eligible_pairings).to eq([pairing1])
    end
  end

  describe '#seed' do
    let(:player1) { create(:player, tournament: tournament, skip_registration: true) }
    let(:player2) { create(:player, tournament: tournament, skip_registration: true) }
    let!(:reg1) { create(:registration, player: player1, stage: stage, seed: 1) }
    let!(:reg2) { create(:registration, player: player2, stage: stage, seed: 2) }

    it 'returns player for correct seeded registration' do
      aggregate_failures do
        expect(stage.seed(1)).to eq(player1)
        expect(stage.seed(2)).to eq(player2)
      end
    end

    it 'handles invalid seed' do
      expect(stage.seed(99)).to eq(nil)
    end
  end

  describe '#single_sided?' do
    context 'swiss' do
      let(:stage) { create(:stage, format: :swiss) }

      it 'is not single sided' do
        expect(stage.single_sided?).to be(false)
      end
    end

    context 'double elim' do
      let(:stage) { create(:stage, format: :double_elim) }

      it 'is not single sided' do
        expect(stage.single_sided?).to be(true)
      end
    end
  end

  describe '#cache_standings!' do
    let(:jack) { create(:player, name: 'Jack') }
    let(:jill) { create(:player, name: 'Jill') }
    let(:round1) { create(:round, stage: stage, completed: true) }
    let(:round2) { create(:round, stage: stage, completed: false) }

    it 'generates standing row entries' do
      stage.players << jack
      stage.players << jill
      create(:pairing, round: round1, player1: jack, player2: jill, score1_corp: 3, score1_runner: 3)
      create(:pairing, round: round2, player1: jack, player2: jill, score1_corp: 3, score2_corp: 3)

      expect do
        stage.cache_standings!
      end.to change { StandingRow.count }.by(2)

      expect(stage.standing_rows.map(&:position)).to eq([1, 2])
      expect(stage.standing_rows.map(&:name)).to eq(%w[Jack Jill])
      expect(stage.standing_rows.map(&:points)).to eq([6, 0])
      expect(stage.standing_rows.map(&:sos)).to eq([0, 6])
      expect(stage.standing_rows.map(&:extended_sos)).to eq([6, 0])
      expect(stage.standing_rows.map(&:corp_points)).to eq([3, 0])
      expect(stage.standing_rows.map(&:runner_points)).to eq([3, 0])
    end
  end
end
