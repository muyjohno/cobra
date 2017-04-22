FactoryGirl.define do
  factory :pairing do
    round
    association :player1, factory: :player
    association :player2, factory: :player
    score1 0
    score2 0
  end
end
