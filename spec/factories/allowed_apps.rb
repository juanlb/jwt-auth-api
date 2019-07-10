# frozen_string_literal: true

FactoryBot.define do
  factory :allowed_app do
    association :user
    association :app
    permissions { '{"role": "admin", "quantity": 1, "code": "abcd", "enabled": true}' }
  end
end
