FactoryGirl.define do
  factory :player do
    name { Faker::Name.name }
    tournament { Tournament.first || create(:tournament) }
    active true
    first_round_bye false

    transient do
      skip_registration false
    end

    after(:create) do |player, evaluator|
      player.tournament.current_stage.players << player unless evaluator.skip_registration
    end
  end
end
