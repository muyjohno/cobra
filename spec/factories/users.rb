FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password 'test1234'
  end
end
