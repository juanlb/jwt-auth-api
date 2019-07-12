class RefreshToken < ApplicationRecord
    belongs_to :allowed_app

    validates :token, :allowed_app_id, uniqueness: true
end
