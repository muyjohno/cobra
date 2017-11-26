RSpec.describe IdentitiesController do
  describe '#index' do
    before do
      create(:identity, name: 'Jack', side: :runner)
      create(:identity, name: 'Jill', side: :runner)
      create(:identity, name: 'Conglomo', side: :corp)
      create(:identity, name: 'DystopiaTech', side: :corp)
    end

    it 'lists corp identities' do
      get identities_path(side: :corp)

      expect(JSON.parse(response.body)).to match_array(['Conglomo', 'DystopiaTech'])
    end

    it 'lists runner identities' do
      get identities_path(side: :runner)

      expect(JSON.parse(response.body)).to match_array(['Jack', 'Jill'])
    end
  end
end
