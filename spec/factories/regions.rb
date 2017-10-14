FactoryGirl.define do
  factory :region do
    name { Faker::Name.name }
    lat { Faker::Address.latitude }
    lng { Faker::Address.longitude }
  end
end