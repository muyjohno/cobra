FactoryGirl.define do
  factory :player do
    name { Faker::Name.name }
    tournament { Tournament.first || create(:tournament) }
    active true
    first_round_bye false

    transient do
      skip_registration false
      seed nil
    end

    after(:create) do |player, evaluator|
      create(
        :registration,
        player: player,
        stage: player.tournament.current_stage,
        seed: evaluator.seed
      ) unless evaluator.skip_registration
    end
  end
end
