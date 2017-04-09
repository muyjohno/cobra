RSpec.describe Tournament do
  let(:tournament) { create(:tournament) }

  describe '#start!' do
    it 'changes tournament status to waiting' do
      tournament.start!

      expect(tournament.waiting?).to be true
    end
  end
end
