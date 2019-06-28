# frozen_string_literal: true

class User < ApplicationRecord

  attr_reader :password

  before_validation :set_secrets, on: :create

  validates :name, :user_key, uniqueness: true, presence: true
  validates :email, email: true, uniqueness: true, presence: true

  validates :password, length: { minimum: 8 }, allow_nil: true


  def password=(password)
    @password = password
    self.encrypted_password = BCrypt::Engine.hash_secret(password, self.salt) if (password and valid?)
  end

  def password_setted
    not encrypted_password.nil?
  end

  def reset_user_key
    self.update_attribute(:user_key, SecretMaker.generate(24))
  end

  private

  def set_secrets
    self.user_key = SecretMaker.generate(24)
    self.salt = BCrypt::Engine.generate_salt
  end
end
