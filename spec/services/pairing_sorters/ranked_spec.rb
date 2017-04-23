RSpec.describe PairingSorters::Ranked do
  let(:player1) { create(:player) }
  let(:player2) { create(:player) }
  let(:player3) { create(:player) }
  let(:player4) { create(:player) }
  let(:player5) { create(:player) }
  let(:player6) { create(:player) }
  let(:pairing1) { create(:pairing, player1: player1, player2: player2) }
  let(:pairing2) { create(:pairing, player1: player3, player2: player4) }
  let(:pairing3) { create(:pairing, player1: player5, player2: player6) }
  let(:pairings) { [pairing1, pairing2, pairing3] }

  before do
    allow(player1).to receive(:points).and_return(3)
    allow(player2).to receive(:points).and_return(1)
    allow(player3).to receive(:points).and_return(6)
    allow(player4).to receive(:points).and_return(0)
    allow(player5).to receive(:points).and_return(3)
    allow(player6).to receive(:points).and_return(2)
  end

  it 'sorts pairings by highest-scoring participant' do
    expect(described_class.sort(pairings)).to eq([pairing2, pairing3, pairing1])
  end
end
