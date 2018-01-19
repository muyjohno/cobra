RSpec.describe IdentitiesController do
  describe '#index' do
    before do
      create(:identity, name: 'Jack', side: :runner)
      create(:identity, name: 'Jill', side: :runner)
      create(:identity, name: 'Conglomo', side: :corp)
      create(:identity, name: 'DystopiaTech', side: :corp)
    end

    it 'lists corp identities' do
      get identities_path

      expect(JSON.parse(response.body)).to eq(
        'corp' => ['Conglomo', 'DystopiaTech'],
        'runner' => ['Jack', 'Jill']
      )
    end
  end
end
