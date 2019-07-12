# frozen_string_literal: true

module JsonConcern
  extend ActiveSupport::Concern

  def clean_malformed_json(malformed_json)
    return '{}' if malformed_json.blank?
    malformed_json.gsub(/\s+/, ' ').gsub('"', "'").strip
  end
end
