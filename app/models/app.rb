class App < ApplicationRecord
    validates :name, :app_key, :jwt_secret, uniqueness: true
    validates :name, :timeout, presence: true

    before_create do
        self.app_key = "#{self.name.parameterize}-#{SecureRandom.hex(64)[0..24]}"
        self.jwt_secret = SecureRandom.hex(64)
    end
end
