FactoryGirl.define do
  factory :user do
    #sequence(:id) { |number| number }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    birth_date { Faker::Date.birthday(18, 65) }
    phone { Faker::PhoneNumber.phone_number } 
    cell_phone { Faker::PhoneNumber.cell_phone } 
    password "123456"
  end
end