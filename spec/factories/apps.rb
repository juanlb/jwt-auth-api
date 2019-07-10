FactoryBot.define do
    factory :app do
        name {Faker::App.name}
        permissions { '{"role": ["admin", "user"], "quantity": "integer", "code": "string", "enabled": "boolean"}' }
        timeout {Faker::Number.number(4)}
    end
end