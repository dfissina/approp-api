FactoryGirl.define do
  factory :property do
    title { Faker::Lorem.sentence(3, true)}
    description {Faker::Lorem.paragraphs}
    bedrooms {Faker::Number.between(1, 7)}
    bathrooms {Faker::Number.between(1, 5)}
    price { Faker::Commerce.price }
    build_mtrs { Faker::Number.between(60, 200) }
    total_mtrs { Faker::Number.between(200, 400) }
    property_type %w[casa departamento].sample
    operation %w[venta arriendo].sample
    state %w[nueva usada].sample
    currency %w[uf clp].sample  
    user_id nil
    street {Faker::Address.street_name}
    number {Faker::Address.building_number}
    departament {Faker::Number.between(1, 10)}
    neighborhood {Faker::Address.community}
    show_pin_map true
    comuna_id nil   
    condominium true
    furniture true
    orientation %w[norte sur oriente poniente norte_sur nororiente norponiente].sample
    pets true
  end
end