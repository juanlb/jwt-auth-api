# frozen_string_literal: true

class App < ApplicationRecord
  JSON_SCHEMA = "#{Rails.root}/app/models/schemas/app/data.json"

  before_validation :set_secrets, on: :create

  validates :name, :app_key, :jwt_secret, uniqueness: true
  validates :name, :timeout, :app_key, :jwt_secret, presence: true
  validates :permissions, json: { schema: JSON_SCHEMA }

  serialize :permissions, Hash

  def permissions=(value)
    write_attribute(:permissions, JSON.parse(value))
  rescue StandardError
    write_attribute(:permissions, JSON.parse('{"invalid": "json"}'))
  end

  def permissions
    read_attribute(:permissions).to_json
  end

  def reset_app_key
    self.update_attribute(:app_key, "#{name.parameterize}-#{SecretMaker.generate(24)}") if name
  end

  def reset_jwt_secret
    self.update_attribute(:jwt_secret, SecretMaker.generate)
  end

  private

  def set_secrets
    self.app_key = "#{name.parameterize}-#{SecretMaker.generate(24)}" if name
    self.jwt_secret = SecretMaker.generate
  end
end
