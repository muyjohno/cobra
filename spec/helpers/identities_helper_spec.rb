RSpec.describe IdentitiesHelper do
  describe '#autocomplete_hash' do
    let(:id) do
      create(:identity,
        name: 'Something hard to type',
        autocomplete: 'Something easy'
      )
    end

    it 'returns has for autocomplete' do
      expect(helper.autocomplete_hash(id)).to eq(
        {
          label: 'Something easy',
          value: 'Something hard to type'
        }
      )
    end
  end
end
