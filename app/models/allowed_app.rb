# frozen_string_literal: true

class AllowedApp < ApplicationRecord
  belongs_to :user
  belongs_to :app

  validates :user_id, uniqueness: { scope: :app_id, message: 'only can be associated with an app once.' }

end
