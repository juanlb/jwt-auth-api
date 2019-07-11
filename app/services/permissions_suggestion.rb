# frozen_string_literal: true

class PermissionsSuggestion
  attr_reader :permissions_array

  def initialize(permissions)
    @permissions_array = JSON.parse(permissions).to_a
  end

  def call
    permissions_schema || {}
  end

  private

  def permissions_schema
    permissions_array.map { |p| PermissionSchema.new(p).suggestion }.inject(:merge)
  end
end
