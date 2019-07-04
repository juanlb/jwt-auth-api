# frozen_string_literal: true

class AllowedApp < ApplicationRecord
  include ::JsonConcern

  JSON_SCHEMA = "#{Rails.root}/app/models/schemas/allowed_app/data.json"

  belongs_to :user
  belongs_to :app

  validates :user_id, :app_id, presence: true
  validates :user_id, uniqueness: { scope: :app_id, message: 'only can be associated with an app once.' }
  validates :permissions, json: { schema: :dynamic_app_schema }, on: :update

  serialize :permissions, Hash

  def permissions=(value)
    write_attribute(:permissions, JSON.parse(value))
  rescue StandardError
    write_attribute(:permissions, JSON.parse('{"malformed": ["json"], "value": "' + clean_malformed_json(value) + '"}'))
  end

  def permissions
    read_attribute(:permissions).to_json
  end

  private

  def dynamic_app_schema
    DynamicSchema.new(app.permissions).call
  end
end
