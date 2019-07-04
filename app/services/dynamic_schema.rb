# frozen_string_literal: true

class DynamicSchema
  def initialize(permissions)
    @permissions_array = JSON.parse(permissions).to_a
  end

  def call
    structure = schema_structure
    structure[:properties].merge!(permissions_schema)
    structure[:required] = required_properties
    structure
  end

  private

  def permissions_schema
    @permissions_array.map { |p| PermissionSchema.new(p).generate }.inject(:merge)
  end

  def schema_structure
    {
      type: 'object',
      additionalProperties: false,
      properties: {
        malformed_json: { not: {} }
      }
    }
  end

  def required_properties
    @permissions_array.map(&:first)
  end
end
