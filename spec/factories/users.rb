FactoryBot.define do
  factory :user do
    nickname              {Faker::Internet.username}
    email                 {Faker::Internet.free_email}
    password              {'1234abc'}
    password_confirmation {'1234abc'}
    first_name            {Gimei.last.kanji}
    last_name             {Gimei.first.kanji}
    first_name_kana       {Gimei.last.katakana}
    last_name_kana        {Gimei.first.katakana}
    birth_date            {Faker::Date.between(from: '1930-01-01', to: 5.year.from_now)}
  end
end


