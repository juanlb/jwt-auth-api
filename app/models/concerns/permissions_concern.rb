# frozen_string_literal: true

module PermissionsConcern
  extend ActiveSupport::Concern

  def permissions_state
    valid_count = allowed_apps.count(&:permissions_valid?)
    { valid: valid_count, invalid: allowed_apps.count - valid_count }
  end
end
