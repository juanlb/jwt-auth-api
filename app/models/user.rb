# frozen_string_literal: true

class User < ApplicationRecord
  include ::PermissionsConcern

  attr_reader :password
  has_many :allowed_apps, dependent: :destroy
  has_many :apps, through: :allowed_apps

  before_validation :set_secrets, on: :create

  validates :name, :user_key, uniqueness: true, presence: true
  validates :email, email: true, uniqueness: true, presence: true

  validates :password, length: { minimum: 6 }, allow_nil: true

  scope :enabled, -> { where(enabled: true) }
  scope :password_setted, -> { where.not(encrypted_password: nil) }

  def self.email_with_password(email, password)
    user = enabled.password_setted.where(email: email).take
    return nil if user.nil?

    user if user.encrypted_password == BCrypt::Engine.hash_secret(password, user.salt)
  end

  def password=(password)
    @password = password
    self.encrypted_password = BCrypt::Engine.hash_secret(password, salt) if password && valid?
  end

  def password_setted?
    !encrypted_password.nil?
  end

  def reset_user_key
    update_attribute(:user_key, SecretGenerator.generate(24))
  end

  def jwt_attributes
    {
      name: name,
      email: email
    }
  end

  private

  def set_secrets
    self.user_key = SecretGenerator.generate(24)
    self.salt = BCrypt::Engine.generate_salt
  end
end
