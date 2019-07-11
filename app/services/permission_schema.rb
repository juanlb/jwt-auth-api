# frozen_string_literal: true

class PermissionSchema
  attr_reader :permission
  def initialize(permission)
    raise 'PermissionSchema needs a Array with 2 items' unless permission.is_a?(Array) && (permission.count == 2)

    @permission = permission
  end

  def generate
    case type
    when 'array'
      generate_array
    when 'string'
      generate_string
    when 'integer'
      generate_integer
    when 'boolean'
      generate_boolean
    else
      raise 'Invalid schema type'
    end
  end

  def suggestion
    case type
    when 'array'
      suggest_array
    when 'string'
      suggest_string
    when 'integer'
      suggest_integer
    when 'boolean'
      suggest_boolean
    else
      raise 'Invalid schema type'
    end
  end

  private

  def suggest_array
    suggest_hash(key, value.first)
  end

  def suggest_string
    suggest_hash(key, "")
  end

  def suggest_integer
    suggest_hash(key, 0)
  end

  def suggest_boolean
    suggest_hash(key, false)
  end

  def suggest_hash(key, value)
    { key.to_sym => value }
  end


  def generate_array
    schema_hash(key, 'string', enum: value)
  end
  
  def generate_integer
    schema_hash(key, 'integer')
  end
  
  def generate_string
    schema_hash(key, 'string')
  end
  
  def generate_boolean
    schema_hash(key, 'boolean')
  end
  
  def schema_hash(key, type, extra_properties = nil)
    properties = {type: type}
    properties.merge! extra_properties if extra_properties
    { key.to_sym => properties }
  end

  def type
    case value
    when Array
      'array'
    when String
      value
    else
      raise 'Invalid schema class'
    end
  end

  def key
    permission.first
  end

  def value
    permission.last
  end
end
