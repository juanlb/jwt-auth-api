FactoryBot.define do
    factory :app do
        name {Faker::App.name}
        timeout {Faker::Number.number(4)}
    end
end