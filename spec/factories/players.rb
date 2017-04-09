FactoryGirl.define do
  factory :player do
    name { Faker::Name.name }
    tournament
  end
end
