FactoryGirl.define do
  factory :tournament do
    name 'Tournament Name'
    stage :swiss

    transient do
      player_count 0
    end

    after(:create) do |tournament, evaluator|
      create_list(:player, evaluator.player_count, tournament: tournament)
    end
  end
end
