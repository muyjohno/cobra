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

  describe '.guess' do
    let!(:jackie) { create(:identity, name: 'Jackie Runner', autocomplete: 'Jackie Runner') }
    let!(:coolcorp) { create(:identity, name: 'C00l C0rp', autocomplete: 'Cool Corp') }
    let!(:ctm) { create(:identity, nrdb_code: 11017) }

    it 'matches approximate guesses' do
      aggregate_failures do
        expect(described_class.guess('jackie runner')).to eq(jackie)
        expect(described_class.guess('jackie')).to eq(jackie)
        expect(described_class.guess('jack')).to eq(jackie)
        expect(described_class.guess('cool')).to eq(coolcorp)
      end
    end

    it 'matches known acronyms' do
      expect(described_class.guess('ctm')).to eq(ctm)
    end

    it 'returns nil for unrecognised names' do
      expect(described_class.guess('nope')).to eq(nil)
    end

    it 'returns nil when no name is provided' do
      expect(described_class.guess(nil)).to eq(nil)
    end

    it 'returns nil when not enough letters are provided' do
      expect(described_class.guess('ja')).to eq(nil)
    end
  end
end
