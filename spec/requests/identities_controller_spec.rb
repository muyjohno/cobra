RSpec.describe IdentitiesController do
  describe '#index' do
    before do
      create(:identity, name: 'Jack', side: :runner, autocomplete: 'Jack')
      create(:identity, name: 'Jill', side: :runner, autocomplete: 'Jill')
      create(:identity, name: 'Conglomo', side: :corp, autocomplete: 'Conglomo')
      create(:identity,
        name: 'Dystöpiæ',
        side: :corp,
        autocomplete: 'Dystopia'
      )
    end

    it 'lists corp identities' do
      get identities_path

      expect(JSON.parse(response.body)).to eq(
        'corp' => [
          { 'label' => 'Conglomo', 'value' => 'Conglomo' },
          { 'label' => 'Dystopia', 'value' => 'Dystöpiæ' }
        ],
        'runner' => [
          { 'label' => 'Jack', 'value' => 'Jack' },
          { 'label' => 'Jill', 'value' => 'Jill' }
        ]
      )
    end
  end
end
