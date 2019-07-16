# frozen_string_literal: true

class JwtRefreshResponseGenerator
  attr_reader :allowed_app
  def initialize(allowed_app)
    @allowed_app = allowed_app
  end

  def call
    return nil if allowed_app.nil?
    {
      jwt: jwt,
      refresh_token: refresh_token
    }
  end

  private

  def payload
    {
      exp: exp,
      permissions_valid: allowed_app.valid?,
    }.merge(JSON.parse(allowed_app.permissions))
     .merge(allowed_app.user.jwt_attributes)
     .merge(allowed_app.app.jwt_attributes)
  end

  def exp
    Time.now.to_i + allowed_app.app.timeout
  end

  def refresh_token
    allowed_app.refresh_token.destroy if allowed_app.refresh_token
    allowed_app.create_refresh_token(token: SecretGenerator.generate(64)).token
  end

  def jwt
    JwtGenerator(payload, allowed_app.app.rsa_private_key).call
  end

end
