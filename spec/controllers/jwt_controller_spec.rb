# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::JwtController, type: :controller do
  describe 'GET #auth' do
    context 'using user_key' do
      let(:allowed_app) { create(:allowed_app) }
      it 'returns http success' do
        post :auth, params: { jwt: { user_key: allowed_app.user.user_key, app_key: allowed_app.app.app_key } }
        expect(response).to have_http_status(:success)
      end

      it 'returns valid jwt' do
        post :auth, params: { jwt: { user_key: allowed_app.user.user_key, app_key: allowed_app.app.app_key } }
        expect(allowed_app.refresh_token).not_to be nil
        expect(JSON.parse(response.body)['refresh_token']).to eq(allowed_app.refresh_token.token)
        expect(algorithm(response)).to eq 'RS256'
        expect(decoded_jwt(response, allowed_app)).to include(JSON.parse(allowed_app.permissions))
      end
    end

    context 'using email and pass' do
      let(:validpass) { 'validpass' }
      let(:allowed_app) { create(:allowed_app) }
      it 'returns http success' do
        allowed_app.user.password = validpass
        allowed_app.user.save
        post :auth, params: { jwt: { email: allowed_app.user.email, password: validpass, app_key: allowed_app.app.app_key } }
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET #refresh' do
    let(:allowed_app) { create(:allowed_app) }
    let(:refresh_token) { JwtGenerator.new(allowed_app).call[:refresh_token] }
    it 'returns http success' do
      post :refresh, params: { jwt: { refresh_token: refresh_token } }
      expect(response).to have_http_status(:success)
    end
  end

  private
  
  def algorithm(response)
    JWT.decode(JSON.parse(response.body)['jwt'], nil, false).last['alg']
  end

  def decoded_jwt(response, allowed_app)
    rsa_public_key = OpenSSL::PKey::RSA.new allowed_app.app.jwt_rsa_public_key
    JWT.decode(JSON.parse(response.body)['jwt'], rsa_public_key, true, {algorithm: algorithm(response)}).first
  end
end
