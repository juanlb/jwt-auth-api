# frozen_string_literal: true

class JwtInputValidator
  attr_reader :params, :app
  def initialize(params, app)
    @params = params
    @app = app
  end

  def get_allowed_app
    user = get_user
    return nil if user.nil?
    return nil if app.nil?

    AllowedApp.where(user: user, app: app).take
  end

  private

  def get_user
    if user_key?
      User.enabled.where(user_key: params[:user_key]).take
    elsif email_password?
      User.email_with_password(params[:email], params[:password])
    end
  end

  def user_key?
    JSON::Validator.validate(user_key_schema, params)
  end

  def email_password?
    JSON::Validator.validate(email_password_schema, params)
  end

  def user_key_schema
    {
      type: 'object',
      properties: {
        user_key: { type: 'string' }
      },
      required: %w[user_key],
      additionalProperties: false
    }
  end

  def email_password_schema
    {
      type: 'object',
      properties: {
        email: { type: 'string' },
        password: { type: 'string' }
      },
      required: %w[email password],
      additionalProperties: false
    }
  end
end
