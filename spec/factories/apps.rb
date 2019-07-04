FactoryBot.define do
    factory :app do
        name {Faker::App.name}
        permissions { '{"active": ["true", "false"], "quantity": "integer", "code": "string"}' }
        timeout {Faker::Number.number(4)}
    end
end