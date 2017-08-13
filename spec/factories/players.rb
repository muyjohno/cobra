FactoryGirl.define do
  factory :player do
    name { Faker::Name.name }
    tournament { Tournament.first || create(:tournament) }
    active true
    first_round_bye false
  end
end
