FactoryBot.define do
    factory :refresh_token do
        token {Faker::Alphanumeric.alpha 64}
        association :allowed_app
    end
end