RSpec.describe PairingSorters::Random do
  let(:pairing1) { create(:pairing) }
  let(:pairing2) { create(:pairing) }
  let(:pairing3) { create(:pairing) }
  let(:pairings) { [pairing1, pairing2, pairing3] }

  let(:shuffled) { double('shuffled') }

  before do
    allow(pairings).to receive(:shuffle).and_return(shuffled)
  end

  it 'sorts pairings by highest-scoring participant' do
    expect(described_class.sort(pairings)).to eq(shuffled)
  end
end
