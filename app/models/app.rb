# frozen_string_literal: true

class App < ApplicationRecord
  include ::JsonConcern
  include ::PermissionsConcern

  JSON_SCHEMA = "#{Rails.root}/app/models/schemas/app/data.json"

  has_many :allowed_apps, :dependent => :restrict_with_error
  has_many :users, through: :allowed_apps

  before_validation :set_secrets, on: :create

  validates :name, :app_key, uniqueness: true
  validates :name, :timeout, :app_key, :rsa_private_key, :rsa_public_key, presence: true
  validates :permissions, json: { schema: JSON_SCHEMA }

  serialize :permissions, Hash

  def permissions=(value)
    write_attribute(:permissions, JSON.parse(value))
  rescue StandardError
    write_attribute(:permissions, JSON.parse('{"malformed_json": "true", "value": "' + clean_malformed_json(value) + '"}'))
  end

  def permissions
    read_attribute(:permissions).to_json
  end

  def reset_app_key
    self.update_attribute(:app_key, "#{name.parameterize}-#{SecretGenerator.generate(24)}") if name
  end

  def reset_rsa_key_pair
    keys = RsaKeyManager.new.create
    self.update_attribute(:rsa_private_key, keys[:rsa_private])
    self.update_attribute(:rsa_public_key, keys[:rsa_public])
  end

  def rsa_private_key
    RsaKeyManager.new.load(read_attribute(:rsa_private_key))
  end

  def jwt_attributes
    {
      app_name: name
    }
  end

  def api_jwt
    payload = {
      app_id: id,
      app_key: app_key
    }
    JsonWebToken.encode(payload)
  end

  private

  def set_secrets
    self.app_key = "#{name.parameterize}-#{SecretGenerator.generate(24)}" if name
    reset_rsa_key_pair
  end
end
