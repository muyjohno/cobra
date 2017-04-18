RSpec.describe Pairer do
  let(:pairer) { Pairer.new(round) }
  let(:round) { create(:round, number: 1, tournament: tournament) }
  let(:tournament) { create(:tournament) }
  let(:nil_player) { double('NilPlayer') }

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

    it 'sets table numbers' do
      pairer.pair!

      round.reload

      expect(round.pairings.map(&:table_number).flatten).to eq([1, 2])
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
  end
end
