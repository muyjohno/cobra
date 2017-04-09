FactoryGirl.define do
  factory :pairing do
    round
    association :player1, factory: :player
    association :player2, factory: :player
  end
end
