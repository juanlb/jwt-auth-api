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
    pl = { permissions_valid: allowed_app.valid? }
    pl[:exp] = exp if exp
    pl.merge(JSON.parse(allowed_app.permissions))
      .merge(allowed_app.user.jwt_attributes)
      .merge(allowed_app.app.jwt_attributes)
    end

  def exp
    Time.now.to_i + allowed_app.app.timeout if allowed_app.app.timeout > 0
  end

  def refresh_token
    allowed_app.refresh_token&.destroy
    allowed_app.create_refresh_token(token: SecretGenerator.generate(64)).token
  end

  def jwt
    JsonWebToken.encode(payload, allowed_app.app.rsa_private_key)
  end
end
