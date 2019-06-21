class App < ApplicationRecord
    before_validation :set_secrets, on: :create

    validates :name, :app_key, :jwt_secret, uniqueness: true
    validates :name, :timeout, :app_key, :jwt_secret, presence: true

    private

    def set_secrets
        self.app_key = "#{self.name.parameterize}-#{SecretMaker.generate(24)}" if self.name
        self.jwt_secret = SecretMaker.generate
    end

end
