RSpec.describe SosCalculator do
  let(:tournament) { create(:tournament) }
  let(:stage) { tournament.current_stage }
  let(:round) { create(:round, stage: stage, completed: true) }
  let!(:snap) { create(:player, tournament: tournament) }
  let!(:crackle) { create(:player, tournament: tournament) }
  let!(:pop) { create(:player, tournament: tournament) }
  let!(:other) { create(:player, tournament: tournament) }
  let(:results) { described_class.calculate!(stage) }
  let(:standing) { results.find{ |p| p.player == snap }}

  context 'with opponents' do

    before do
      create(:pairing, player1: snap, player2: crackle, score1: 6, score2: 0, round: round)
      create(:pairing, player1: pop, player2: other, score1: 6, score2: 0, round: round)

      create(:pairing, player1: snap, player2: pop, score1: 6, score2: 0, round: round)
      create(:pairing, player1: crackle, player2: other, score1: 3, score2: 3, round: round)
    end

    it 'calculates sos' do
      expect(standing.sos).to eq(2.25)
    end

    it 'calculates extended sos' do
      expect(standing.extended_sos).to eq(3.75)
    end
  end

  describe 'points' do
    before do
      create(:pairing, player1: snap, score1: 5, round: round)
      create(:pairing, player1: snap, score1: 2, player2: nil, round: round)
    end

    it 'returns total of all points from pairings including byes' do
      expect(standing.points).to eq(7)
    end
  end

  describe 'sos' do
    before do
      other = create(:player)
      # player played two games, including against opponent 'other'
      create(:pairing, player1: snap, player2: other, score1: 3, score2: 2, round: round)
      create(:pairing, player1: snap, score1: 1, score2: 3, round: round)
      # other played one other eligible game
      create(:pairing, player2: other, score1: 0, score2: 5, round: round)
    end

    it 'calculates sos' do
      expect(standing.sos).to eq(3.25)
    end

    describe 'extended_sos' do
      it 'calculates extended sos' do
        expect(standing.extended_sos).to eq(1.5)
      end
    end
  end

  context 'player with only byes' do
    before do
      create(:pairing, player1: snap, player2: nil, score1: 6, score2: 0, round: round)
    end

    it 'calculates standing' do
      aggregate_failures do
        expect(standing.points).to eq(6)
        expect(standing.sos).to eq(0.0)
        expect(standing.extended_sos).to eq(0.0)
      end
    end
  end

  context 'three person tourney example' do
    let(:three_person) { create(:tournament) }
    let(:stage) { three_person.current_stage }
    let(:laurie) { create(:player, tournament: three_person) }
    let(:dan) { create(:player, tournament: three_person) }
    let(:johno) { create(:player, tournament: three_person) }
    let(:results) { described_class.calculate!(stage) }

    before do
      create(:pairing, player1: dan, player2: johno, score1: 3, score2: 3, round: round)
      create(:pairing, player1: laurie, player2: nil, score1: 6, score2: 0, round: round)
      create(:pairing, player1: laurie, player2: johno, score1: 6, score2: 0, round: round)
      create(:pairing, player1: dan, player2: nil, score1: 6, score2: 0, round: round)
    end

    it 'calculates standings' do
      aggregate_failures do
        expect(results[0].player).to eq(laurie)
        expect(results[0].points).to eq(12)
        expect(results[0].sos).to eq(1.5)
        expect(results[0].extended_sos).to eq(5.25)
        expect(results[1].player).to eq(dan)
        expect(results[1].points).to eq(9)
        expect(results[1].sos).to eq(1.5)
        expect(results[1].extended_sos).to eq(5.25)
        expect(results[2].player).to eq(johno)
        expect(results[2].points).to eq(3)
        expect(results[2].sos).to eq(5.25)
        expect(results[2].extended_sos).to eq(1.5)
      end
    end
  end

  context 'weighted round example' do
    let(:weighted) { create(:tournament) }
    let(:stage) { weighted.current_stage }
    let(:alpha) { create(:player, tournament: weighted) }
    let(:beta) { create(:player, tournament: weighted) }
    let(:gamma) { create(:player, tournament: weighted) }
    let(:delta) { create(:player, tournament: weighted) }
    let(:round1) { create(:round, stage: stage, weight: 1.0, completed: true) }
    let(:round2) { create(:round, stage: stage, weight: 0.5, completed: true) }
    let(:results) { described_class.calculate!(stage) }

    before do
      create(:pairing, player1: alpha, player2: beta, score1: 6, score2: 0, round: round1)
      create(:pairing, player1: gamma, player2: delta, score1: 3, score2: 3, round: round1)
      create(:pairing, player1: alpha, player2: gamma, score1: 3, score2: 0, round: round2)
      create(:pairing, player1: beta, player2: delta, score1: 0, score2: 3, round: round2)
    end

    it 'calculates weighted SOS' do
      aggregate_failures do
        expect(results[0].player).to eq(alpha)
        expect(results[0].points).to eq(9)
        expect(results[0].sos.round(4)).to eq(0.6667)
        expect(results[0].extended_sos.round(4)).to eq(5.1111)
        expect(results[1].player).to eq(delta)
        expect(results[1].points).to eq(6)
        expect(results[1].sos.round(4)).to eq(1.3333)
        expect(results[1].extended_sos.round(4)).to eq(4.8889)
        expect(results[2].player).to eq(gamma)
        expect(results[2].points).to eq(3)
        expect(results[2].sos.round(4)).to eq(4.6667)
        expect(results[2].extended_sos.round(4)).to eq(1.1111)
        expect(results[3].player).to eq(beta)
        expect(results[3].points).to eq(0)
        expect(results[3].sos.round(4)).to eq(5.3333)
        expect(results[3].extended_sos.round(4)).to eq(0.8889)
      end
    end
  end

  describe 'corp and runner points' do
    before do
      create(:pairing, player1: snap, player2: crackle, score1_corp: 3, score1_runner: 3, round: round)
      create(:pairing, player1: snap, player2: pop, score1_corp: 1, score2_corp: 3, round: round)
    end

    it 'calculates side points' do
      aggregate_failures do
        expect(standing.corp_points).to eq(4)
        expect(standing.runner_points).to eq(3)
      end
    end
  end
end
