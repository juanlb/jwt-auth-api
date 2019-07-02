# frozen_string_literal: true

FactoryBot.define do
  factory :allowed_app do
    association :user
    association :app
    permissions { nil }
  end
end
