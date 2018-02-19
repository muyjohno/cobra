RSpec.describe Tournament do
  let(:tournament) { create(:tournament, player_count: 4) }

  it 'automatically populates slug' do
    sample = create(:tournament, slug: nil)

    expect(sample).to be_valid
    expect(sample.slug).not_to eq(nil)
  end

  it 'does not overwrite slug' do
    expect do
      tournament.update(name: 'new name')
    end.not_to change(tournament, :slug)
  end

  it 'automatically populates date' do
    expect(tournament.date).to eq(Date.today)
  end

  it 'automatically creates stage' do
    expect do
      tournament
    end.to change(Stage, :count).by(1)

    stage = tournament.stages.last

    expect(stage.number).to eq(1)
    expect(stage.swiss?).to be(true)
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

  describe '#corp_counts' do
    let!(:identity) { create(:identity, name: 'Something') }
    let!(:other_identity) { create(:identity, name: 'Something else') }

    before do
      tournament.players = [
        create(:player, corp_identity: 'Something'),
        create(:player, corp_identity: 'Something'),
        create(:player, corp_identity: 'Something else')
      ]
    end

    it 'returns counts' do
      expect(tournament.corp_counts).to eq([
        [identity, 2],
        [other_identity, 1]
      ])
    end
  end

  describe '#runner_counts' do
    let!(:identity) { create(:identity, name: 'Some runner') }

    before do
      tournament.players = [
        create(:player, runner_identity: 'Some runner')
      ]
    end

    it 'returns counts' do
      expect(tournament.runner_counts).to eq([
        [identity, 1]
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

  describe '#current_stage' do
    let!(:new_stage) { create(:stage, tournament: tournament, number: 2) }

    it 'returns last stage' do
      expect(tournament.current_stage).to eq(new_stage)
    end
  end
end
