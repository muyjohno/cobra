RSpec.describe Standing do
  let(:player) { create(:player) }
  let(:standing) { Standing.new(player) }

  describe '#corp_identity' do
    let!(:identity) { create(:identity, name: 'RP') }

    before { player.corp_identity = 'RP' }

    it 'delegates to player' do
      expect(standing.corp_identity).to eq(identity)
    end
  end

  describe '#runner_identity' do
    let!(:identity) { create(:identity, name: 'Reina Roja') }

    before { player.runner_identity = 'Reina Roja' }

    it 'delegates to player' do
      expect(standing.runner_identity).to eq(identity)
    end
  end

  describe 'sorting' do
    # manual seeding should be ignored on unflagged tournaments
    let(:other) { create(:player, manual_seed: 1) }

    it 'sorts by points' do
      expect(
        Standing.new(player, points: 3) <=> Standing.new(other, points: 0)
      ).to eq(-1)
      expect(
        Standing.new(player, points: 2) <=> Standing.new(other, points: 2)
      ).to eq(0)
      expect(
        Standing.new(player, points: 1) <=> Standing.new(other, points: 5)
      ).to eq(1)
    end

    it 'sorts by sos' do
      expect(
        Standing.new(player,
          points: 3,
          sos: 2.0
        ) <=> Standing.new(other,
          points: 3,
          sos: 1.8
        )
      ).to eq(-1)
      expect(
        Standing.new(player,
          points: 3,
          sos: 2.0
        ) <=> Standing.new(other,
          points: 3,
          sos: 2.0
        )
      ).to eq(0)
      expect(
        Standing.new(player,
          points: 3,
          sos: 1.4
        ) <=> Standing.new(other,
          points: 3,
          sos: 1.8
        )
      ).to eq(1)
    end

    it 'sorts by extended sos' do
      expect(
        Standing.new(player,
          points: 3,
          sos: 2.0,
          extended_sos: 3.3
        ) <=> Standing.new(other,
          points: 3,
          sos: 2.0,
          extended_sos: 1.3
        )
      ).to eq(-1)
      expect(
        Standing.new(player,
          points: 3,
          sos: 2.0,
          extended_sos: 3.3
        ) <=> Standing.new(other,
          points: 3,
          sos: 2.0,
          extended_sos: 3.3
        )
      ).to eq(0)
      expect(
        Standing.new(player,
          points: 3,
          sos: 2.0,
          extended_sos: 0.3
        ) <=> Standing.new(other,
          points: 3,
          sos: 2.0,
          extended_sos: 1.3
        )
      ).to eq(1)
    end

    context 'with manual seed tournament' do
      let(:tournament) { create(:tournament, manual_seed: true) }
      let(:other) { create(:player, tournament: tournament, manual_seed: 2) }

      context 'when player is seeded' do
        let(:player) { create(:player, tournament: tournament, manual_seed: 1) }

        it 'sorts by points' do
          expect(
            Standing.new(player, points: 3) <=> Standing.new(other, points: 0)
          ).to eq(-1)
          expect(
            Standing.new(player, points: 1) <=> Standing.new(other, points: 5)
          ).to eq(1)
        end

        it 'sorts by seed before sos' do
          expect(
            Standing.new(player,
              points: 3,
              sos: 2.0
            ) <=> Standing.new(other,
              points: 3,
              sos: 1.8
            )
          ).to eq(-1)
          expect(
            Standing.new(player,
              points: 3,
              sos: 2.0
            ) <=> Standing.new(other,
              points: 3,
              sos: 2.0
            )
          ).to eq(-1)
          expect(
            Standing.new(player,
              points: 3,
              sos: 1.4
            ) <=> Standing.new(other,
              points: 3,
              sos: 1.8
            )
          ).to eq(-1)
        end

        context 'when seed is equal' do
          let(:other) { create(:player, tournament: tournament, manual_seed: 1) }

          it 'sorts by sos' do
            expect(
              Standing.new(player,
                points: 3,
                sos: 2.0
              ) <=> Standing.new(other,
                points: 3,
                sos: 1.8
              )
            ).to eq(-1)
            expect(
              Standing.new(player,
                points: 3,
                sos: 2.0
              ) <=> Standing.new(other,
                points: 3,
                sos: 2.0
              )
            ).to eq(0)
            expect(
              Standing.new(player,
                points: 3,
                sos: 1.4
              ) <=> Standing.new(other,
                points: 3,
                sos: 1.8
              )
            ).to eq(1)
          end
        end
      end

      context 'when player is unseeded' do
        let(:player) { create(:player, tournament: tournament, manual_seed: nil) }

        it 'sorts by points' do
          expect(
            Standing.new(player, points: 3) <=> Standing.new(other, points: 0)
          ).to eq(-1)
          expect(
            Standing.new(player, points: 1) <=> Standing.new(other, points: 5)
          ).to eq(1)
        end

        it 'sorts by seed before sos' do
          expect(
            Standing.new(player,
              points: 3,
              sos: 2.0
            ) <=> Standing.new(other,
              points: 3,
              sos: 1.8
            )
          ).to eq(1)
          expect(
            Standing.new(player,
              points: 3,
              sos: 2.0
            ) <=> Standing.new(other,
              points: 3,
              sos: 2.0
            )
          ).to eq(1)
          expect(
            Standing.new(player,
              points: 3,
              sos: 1.4
            ) <=> Standing.new(other,
              points: 3,
              sos: 1.8
            )
          ).to eq(1)
        end

        context 'when seed is equal' do
          let(:other) { create(:player, tournament: tournament, manual_seed: nil) }

          it 'sorts by sos' do
            expect(
              Standing.new(player,
                points: 3,
                sos: 2.0
              ) <=> Standing.new(other,
                points: 3,
                sos: 1.8
              )
            ).to eq(-1)
            expect(
              Standing.new(player,
                points: 3,
                sos: 2.0
              ) <=> Standing.new(other,
                points: 3,
                sos: 2.0
              )
            ).to eq(0)
            expect(
              Standing.new(player,
                points: 3,
                sos: 1.4
              ) <=> Standing.new(other,
                points: 3,
                sos: 1.8
              )
            ).to eq(1)
          end
        end
      end
    end
  end
end
