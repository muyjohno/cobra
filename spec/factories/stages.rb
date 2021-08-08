FactoryBot.define do
  factory :stage do
    tournament
    format { :swiss }
  end
end
