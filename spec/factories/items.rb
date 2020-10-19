FactoryBot.define do
  factory :item do
    name               { Faker::Lorem.word }
    text               { Faker::Lorem.paragraph }
    price              { Faker::Number.between(from: 300, to: 9_999_999) }
    status_id          { Faker::Number.between(from: 1, to: 6) }
    category_id        { Faker::Number.between(from: 1, to: 10) }
    prefecture_id      { Faker::Number.between(from: 1, to: 47) }
    day_id             { Faker::Number.between(from: 1, to: 3) }
    delivery_charge_id { Faker::Number.between(from: 1, to: 2) }

    association :user

    after(:build) do |item|
      item.images.attach(io: File.open('public/images/test_image.png'), filename: 'test_image.png')
    end
  end
end
