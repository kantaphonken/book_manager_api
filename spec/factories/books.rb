FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    author { Faker::Book.author }
    genre { Faker::Book.genre }
    publication_year { Faker::Number.between(from: 1800, to: 2024) }
  end
end
