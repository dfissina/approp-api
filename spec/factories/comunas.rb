FactoryGirl.define do
  factory :comuna do
    name { Faker::Name.name }
    lat { Faker::Address.latitude }
    lng { Faker::Address.longitude }
    region_id nil
  end
end