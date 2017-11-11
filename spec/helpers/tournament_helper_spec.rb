RSpec.describe TournamentHelper do
  describe '#short_date' do
    let(:tournament) { create(:tournament, created_at: '2017/01/02', date: '2017/01/04') }

    it 'returns date when date exists' do
      expect(helper.short_date(tournament)).to eq('4 Jan 2017')
    end

    it 'returns nil when no date is set' do
      tournament.update(date: nil)

      expect(helper.short_date(tournament)).to eq(nil)
    end
  end
end
