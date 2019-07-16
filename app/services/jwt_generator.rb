# frozen_string_literal: true

class JwtGenerator

    def initialize(payload, private_key)
        @payload = payload
        @private_key = private_key
    end

    def call
        JWT.encode payload, private_key, 'RS256'
    end
end