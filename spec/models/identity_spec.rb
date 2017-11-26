RSpec.describe Identity do
  describe '.valid?' do
    before do
      create(:identity, name: 'My Rad Identity: 2 Cool 4 School')
    end

    it 'matches valid IDs' do
      expect(described_class.valid?('My Rad Identity: 2 Cool 4 School')).to eq(true)
    end

    it 'identifies invalid IDs' do
      expect(described_class.valid?('Who Dis')).to eq(false)
    end
  end
end
