FactoryBot.define do
  factory :like do
    association :user
    association :item
  end
end
