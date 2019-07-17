# frozen_string_literal: true

class JsonWebToken
  SECRET_KEY = Rails.application.secrets.secret_key_base. to_s
  ALGORITHM = 'RS256'

  def self.encode(payload, private_key = nil)
    if private_key
      JWT.encode payload, private_key, ALGORITHM
    else
      JWT.encode(payload, SECRET_KEY)
    end
  end

  def self.decode(token, public_key = nil)
    decoded = if public_key
                JWT.decode(token, public_key, true, algorithm: ALGORITHM)[0]
              else
                JWT.decode(token, SECRET_KEY)[0]
              end
    HashWithIndifferentAccess.new decoded
  end
end
