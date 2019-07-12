# frozen_string_literal: true

class JwtInputValidator

  attr_reader :params
  def initialize(params)
    @params = params
  end

  def get_allowed_app
    user = get_user
    return nil if user.nil?
    return nil if app.nil?
    AllowedApp.where(user: user, app: app).take
  end

  private

  def app
    @app ||= App.where(app_key: params[:app_key]).take
  end

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
        user_key: { type: 'string' },
        app_key: { type: 'string' }
      },
      required: %w[user_key app_key],
      additionalProperties: false
    }
  end

  def email_password_schema
    {
      type: 'object',
      properties: {
        email: { type: 'string' },
        password: { type: 'string' },
        app_key: { type: 'string' }
      },
      required: %w[email password app_key],
      additionalProperties: false
    }
  end
end
