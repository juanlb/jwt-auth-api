# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::AuthController, type: :routing do
  describe 'routing' do
    it 'routes to #login' do
      expect(post: '/api/v1/auth/login').to route_to('api/v1/auth#login')
    end
    
    it 'routes to #refresh' do
      expect(post: '/api/v1/auth/refresh').to route_to('api/v1/auth#refresh')
    end

    it 'routes to #valid' do
      expect(post: '/api/v1/auth/valid').to route_to('api/v1/auth#valid')
    end

    it 'routes to #public_key' do
      expect(get: '/api/v1/auth/public_key').to route_to('api/v1/auth#public_key')
    end
  end
end
