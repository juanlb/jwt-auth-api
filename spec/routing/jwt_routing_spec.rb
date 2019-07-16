# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::JwtController, type: :routing do
  describe 'routing' do
    it 'routes to #auth' do
      expect(post: '/api/v1/jwt/auth').to route_to('api/v1/jwt#auth')
    end
    
    it 'routes to #refresh' do
      expect(post: '/api/v1/jwt/refresh').to route_to('api/v1/jwt#refresh')
    end

    it 'routes to #valid' do
      expect(post: '/api/v1/jwt/valid').to route_to('api/v1/jwt#valid')
    end

    it 'routes to #public_key' do
      expect(post: '/api/v1/jwt/public_key').to route_to('api/v1/jwt#public_key')
    end
  end
end
