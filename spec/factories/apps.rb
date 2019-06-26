FactoryBot.define do
    factory :app do
        name {Faker::App.name}
        permissions { '{"attr1": ["value1", "value2"]}' }
        timeout {Faker::Number.number(4)}
    end
end