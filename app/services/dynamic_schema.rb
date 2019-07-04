# frozen_string_literal: true

class DynamicSchema
  def initialize(permissions)
    @permissions_array = JSON.parse(permissions).to_a
  end

  def call
    permissions_schema = @permissions_array.map { |p| PermissionSchema.new(p).generate }.inject(:merge)
    add_restrictions(permissions_schema)
  end

  private

  def add_restrictions(permissions_schema)
    schema_restrictions =
      { type: 'object',
        additionalProperties: false,
        properties: {
          malformed_json: { not: {} }
        } }

    schema_restrictions[:properties].merge!(permissions_schema)
    schema_restrictions
  end
end
