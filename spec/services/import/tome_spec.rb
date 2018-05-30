RSpec.describe Import::Tome do
  let(:tournament) { create(:tournament) }
  let(:importer) { described_class.new(raw) }
  let(:import!) { importer.apply(tournament) }

  context 'importing swiss tournament' do
    let(:raw) { file_fixture('tome_export.json').read }

    it 'deletes and replaces existing data' do
      create_list(:player, 6, tournament: tournament)

      expect do
        import!
      end.to change(tournament.players, :count).by(-2)
    end

    it 'creates a swiss stage' do
      import!

      expect(tournament.stages.map(&:format)).to eq(['swiss'])
    end

    it 'populates identities' do
      create(:identity, name: 'Titan Transnational', autocomplete: 'Titan Transnational')
      create(:identity, name: 'P-a-l-a-n-a Foods', autocomplete: 'Palana Foods')
      create(:identity, name: 'NBN: Controlling the Message', autocomplete: 'NBN: Controlling the Message')
      create(:identity, name: 'Architects of Tomorrow', autocomplete: 'Architects of Tomorrow', nrdb_code: '11072')
      create(:identity, name: 'Valencia Estevez', autocomplete: 'Valencia Estevez')
      create(:identity, name: 'Rielle "Kit" Peddler', autocomplete: 'Rielle "Kit" Peddler')

      import!

      aggregate_failures do
        expect(tournament.players.map(&:corp_identity)).to eq(
          [
            'Titan Transnational',
            'P-a-l-a-n-a Foods',
            'NBN: Controlling the Message',
            'Architects of Tomorrow'
          ]
        )

        expect(tournament.players.map(&:runner_identity)).to eq(
          [
            'Valencia Estevez',
            'Rielle "Kit" Peddler',
            nil,
            nil
          ]
        )
      end
    end

    describe 'created stage' do
      let(:stage) do
        import!

        tournament.stages.first
      end
      let(:standings) { stage.standings.players }

      it 'updates rounds and pairings' do
        aggregate_failures do
          expect(standings[0].name).to eq('Jack Smith')
          expect(standings[0].points).to eq(9)
          expect(standings[1].name).to eq('Gretel Bacon')
          expect(standings[1].points).to eq(9)
          expect(standings[2].name).to eq('Jill Jones')
          expect(standings[2].points).to eq(6)
          expect(standings[3].name).to eq('Hansel Adams')
          expect(standings[3].points).to eq(0)
        end
      end
    end
  end

  context 'importing cut tournament' do
    let(:raw) { file_fixture('tome_cut_export.json').read }

    it 'creates two stages' do
      import!

      expect(tournament.stages.map(&:format)).to eq(['swiss', 'double_elim'])
    end

    describe 'swiss stage' do
      let(:stage) do
        import!

        tournament.stages.first
      end
      let(:standings) { stage.standings.players }

      it 'updates rounds and pairings' do
        aggregate_failures do
          expect(stage.rounds.all?(&:completed?))
          expect(standings[0].name).to eq('Jack Smith')
          expect(standings[0].points).to eq(9)
          expect(standings[1].name).to eq('Gretel Bacon')
          expect(standings[1].points).to eq(9)
          expect(standings[2].name).to eq('Jill Jones')
          expect(standings[2].points).to eq(6)
          expect(standings[3].name).to eq('Hansel Adams')
          expect(standings[3].points).to eq(0)
        end
      end
    end

    describe 'cut stage' do
      let(:stage) do
        import!

        tournament.stages.last
      end

      it 'updates rounds and pairings' do
        aggregate_failures do
          expect(stage.rounds.count).to eq(1)
          expect(stage.rounds.first.pairings.count).to eq(2)
        end
      end
    end
  end
end
