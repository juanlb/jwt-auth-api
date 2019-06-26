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
  end

  def permissions
    read_attribute(:permissions).to_json
  end

  private

  def set_secrets
    self.app_key = "#{name.parameterize}-#{SecretMaker.generate(24)}" if name
    self.jwt_secret = SecretMaker.generate
  end
end
