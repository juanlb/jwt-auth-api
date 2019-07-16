# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::JwtController, type: :controller do
  describe 'POST #auth' do
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

    context 'using invalid user_key' do
      let(:allowed_app) { create(:allowed_app) }
      let(:user_key) { 'invalid_user_key' }
      it 'returns http bad_request' do
        post :auth, params: { jwt: { user_key: user_key, app_key: allowed_app.app.app_key } }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'using invalid app_key' do
      let(:allowed_app) { create(:allowed_app) }
      let(:app_key) { 'invalid_app_key' }
      it 'returns http bad_request' do
        post :auth, params: { jwt: { user_key: allowed_app.user.user_key, app_key: app_key } }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'using email and pass' do
      let(:validpass) { 'validpass' }
      let(:allowed_app) { create(:allowed_app) }
      it 'returns http bad_request' do
        allowed_app.user.password = validpass
        allowed_app.user.save
        post :auth, params: { jwt: { email: allowed_app.user.email, password: validpass, app_key: allowed_app.app.app_key } }
        expect(response).to have_http_status(:success)
      end
    end

    context 'using email and invalid pass' do
      let(:validpass) { 'validpass' }
      let(:allowed_app) { create(:allowed_app) }
      let(:invalid_pass) { 'invalid_pass' }
      it 'returns http bad_request' do
        allowed_app.user.password = validpass
        allowed_app.user.save
        post :auth, params: { jwt: { email: allowed_app.user.email, password: invalid_pass, app_key: allowed_app.app.app_key } }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'using email and invalid pass' do
      let(:validpass) { 'validpass' }
      let(:allowed_app) { create(:allowed_app) }
      let(:email) { 'invalid_email' }
      it 'returns http bad_request' do
        allowed_app.user.password = validpass
        allowed_app.user.save
        post :auth, params: { jwt: { email: email, password: validpass, app_key: allowed_app.app.app_key } }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'POST #refresh' do
    context 'valid refresh token' do
      let(:allowed_app) { create(:allowed_app) }
      let(:refresh_token) { JwtRefreshResponseGenerator.new(allowed_app).call[:refresh_token] }
      it 'returns http success' do
        post :refresh, params: { jwt: { refresh_token: refresh_token } }
        expect(response).to have_http_status(:success)
      end
    end

    context 'invalid refresh token' do
      let(:allowed_app) { create(:allowed_app) }
      let(:refresh_token) { JwtRefreshResponseGenerator.new(allowed_app).call[:refresh_token] }
      let(:invalid_refresh_token) { 'invalid_refresh_token' }
      it 'returns http bad_request' do
        post :refresh, params: { jwt: { refresh_token: invalid_refresh_token } }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'POST #valid' do
    context 'valid token' do
      let(:allowed_app) { create(:allowed_app) }
      let(:jwt_token) { JwtRefreshResponseGenerator.new(allowed_app).call[:jwt] }
      it 'returns http success' do
        post :valid, params: { jwt: { jwt_token: jwt_token, app_key: allowed_app.app.app_key } }
        expect(response).to have_http_status(:success)
      end
    end

    context 'invalid token' do
      let(:allowed_app) { create(:allowed_app) }
      let(:jwt_token) { 'error' + JwtRefreshResponseGenerator.new(allowed_app).call[:jwt] }
      it 'returns http unauthorized Unknown error' do
        post :valid, params: { jwt: { jwt_token: jwt_token, app_key: allowed_app.app.app_key } }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq('error' => 'Unknown error')
      end
    end

    context 'token from other user' do
      let(:allowed_app) { create(:allowed_app) }
      let(:allowed_app_invalid) { create(:allowed_app) }
      let(:jwt_token) { JwtRefreshResponseGenerator.new(allowed_app_invalid).call[:jwt] }
      it 'returns http unauthorized Verification Signature Fail' do
        post :valid, params: { jwt: { jwt_token: jwt_token, app_key: allowed_app.app.app_key } }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq('error' => 'Verification Signature Fail')
      end
    end
  end

  describe 'POST #public_key' do
    let(:app) { create(:app) }
    context 'valid app_key' do
      let(:app_key) { app.app_key }
      it 'returns http success' do
        post :public_key, params: { jwt: { app_key: app_key } }
        expect(response).to have_http_status(:success)
      end

      it 'returns the app public key' do
        post :public_key, params: { jwt: { app_key: app_key } }
        expect(JSON.parse(response.body)['public_key']).to eq app.jwt_rsa_public_key
      end
    end

    context 'invalid app_key' do
      let(:app_key) { 'invalid_app_key' }
      it 'returns http bad_request' do
        post :public_key, params: { jwt: { app_key: app_key } }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  private

  def algorithm(response)
    JWT.decode(JSON.parse(response.body)['jwt'], nil, false).last['alg']
  end

  def decoded_jwt(response, allowed_app)
    rsa_public_key = OpenSSL::PKey::RSA.new allowed_app.app.jwt_rsa_public_key
    JWT.decode(JSON.parse(response.body)['jwt'], rsa_public_key, true, algorithm: algorithm(response)).first
  end
end
