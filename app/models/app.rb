# frozen_string_literal: true

class App < ApplicationRecord
  include ::JsonConcern
  include ::PermissionsConcern

  JSON_SCHEMA = "#{Rails.root}/app/models/schemas/app/data.json"

  has_many :allowed_apps, :dependent => :restrict_with_error
  has_many :users, through: :allowed_apps

  before_validation :set_secrets, on: :create

  validates :name, :app_key, uniqueness: true
  validates :name, :timeout, :app_key, :jwt_rsa_private_key, :jwt_rsa_public_key, presence: true
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

  def reset_jwt_secret
    keys = RsaKeyManager.new.create
    self.update_attribute(:jwt_rsa_private_key, keys[:rsa_private])
    self.update_attribute(:jwt_rsa_public_key, keys[:rsa_public])
  end

  def rsa_private_key
    RsaKeyManager.new.load(jwt_rsa_private_key)
  end

  def jwt_attributes
    {
      app_name: name
    }
  end

  private

  def set_secrets
    self.app_key = "#{name.parameterize}-#{SecretGenerator.generate(24)}" if name
    reset_jwt_secret
  end
end
