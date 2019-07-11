# frozen_string_literal: true

class JwtChecker
  attr_reader :app, :jwt
  def initialize(app, jwt)
    @app = app
    @jwt = jwt
  end

  def call
    return { response: { error: 'Unknown entities' }, status: :unauthorized } if app.nil? || jwt.nil?

    rsa_public_key = OpenSSL::PKey::RSA.new(app.jwt_rsa_public_key)
    JWT.decode(jwt, rsa_public_key, true, algorithm: algorithm)

    { response: { message: 'Valid token' }, status: :success }
  rescue JWT::VerificationError
    { response: { error: 'Verification Signature Fail' }, status: :unauthorized }
  rescue JWT::ExpiredSignature
    { response: { error: 'Expired token' }, status: :unauthorized }
  rescue StandardError
    { response: { error: 'Unknown error' }, status: :unauthorized }
  end

  private

  def algorithm
    JWT.decode(jwt, nil, false).last['alg']
  end
end
