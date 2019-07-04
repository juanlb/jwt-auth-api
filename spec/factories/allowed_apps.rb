# frozen_string_literal: true

FactoryBot.define do
  factory :allowed_app do
    association :user
    association :app
    permissions { '{"active": "true", "quantity": 1, "code": "abcd"}' }
  end
end
