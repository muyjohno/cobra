FactoryBot.define do
  factory :identity do
    name { 'Mr Runner' }
    side { :runner }
    faction { :shaper }
    nrdb_code { '00001' }
    autocomplete { 'Mr Runner' }
  end
end
