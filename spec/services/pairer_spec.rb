RSpec.describe Pairer do
  let(:pairer) { Pairer.new(round) }
  let(:round) { create(:round, number: 1, tournament: tournament) }
  let(:tournament) { create(:tournament) }

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
      ).to contain_exactly(snap, crackle, pop, nil)
    end
  end
end
