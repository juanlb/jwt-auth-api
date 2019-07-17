# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::AuthController, type: :controller do
  describe 'POST #auth' do
    before { request.headers.merge!('Authorization' => "Bearer #{allowed_app.app.api_jwt}") }
    let(:allowed_app) { create(:allowed_app) }
    context 'using user_key' do
      it 'returns http success' do
        post :login, params: { auth: { user_key: allowed_app.user.user_key } }
        expect(response).to have_http_status(:success)
      end

      it 'returns valid jwt' do
        post :login, params: { auth: { user_key: allowed_app.user.user_key } }
        expect(allowed_app.refresh_token).not_to be nil
        expect(JSON.parse(response.body)['refresh_token']).to eq(allowed_app.refresh_token.token)
        expect(decoded_jwt(response, allowed_app)).to include(JSON.parse(allowed_app.permissions))
      end
    end

    context 'using user_key using app with 0 timeout' do
      let(:app) { create(:app, timeout: 0) }
      let(:allowed_app) { create(:allowed_app, app: app) }

      it 'returns valid jwt with no exp param' do
        post :login, params: { auth: { user_key: allowed_app.user.user_key } }
        expect(decoded_jwt(response, allowed_app)).not_to have_key('exp')
      end
    end

    context 'using invalid user_key' do
      let(:user_key) { 'invalid_user_key' }
      it 'returns http bad_request' do
        post :login, params: { auth: { user_key: user_key } }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'using api_jwt from other app' do
      let(:invalid_api_jwt) { create(:app).api_jwt }
      it 'returns http bad_request' do
        request.headers.merge!('Authorization' => "Bearer #{invalid_api_jwt}")
        post :login, params: { auth: { user_key: allowed_app.user.user_key } }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'using api_jwt from inexistent app' do
      let(:invalid_api_jwt) { JsonWebToken.encode(app_id: 0) }
      it 'returns http unauthorized' do
        request.headers.merge!('Authorization' => "Bearer #{invalid_api_jwt}")
        post :login, params: { auth: { user_key: allowed_app.user.user_key } }
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'using api_jwt from app with renewed app_key' do
      it 'returns http unauthorized' do
        allowed_app.app.reset_app_key
        post :login, params: { auth: { user_key: allowed_app.user.user_key } }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq('errors' => 'Invalid app_key')
      end
    end

    context 'using email and pass' do
      let(:validpass) { 'validpass' }
      it 'returns http bad_request' do
        allowed_app.user.password = validpass
        allowed_app.user.save
        post :login, params: { auth: { email: allowed_app.user.email, password: validpass } }
        expect(response).to have_http_status(:success)
      end
    end

    context 'using email and invalid pass' do
      let(:validpass) { 'validpass' }
      let(:invalid_pass) { 'invalid_pass' }
      it 'returns http bad_request' do
        allowed_app.user.password = validpass
        allowed_app.user.save
        post :login, params: { auth: { email: allowed_app.user.email, password: invalid_pass } }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'using email and invalid pass' do
      let(:validpass) { 'validpass' }
      let(:email) { 'invalid_email' }
      it 'returns http bad_request' do
        allowed_app.user.password = validpass
        allowed_app.user.save
        post :login, params: { auth: { email: email, password: validpass } }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'POST #refresh' do
    before { request.headers.merge!('Authorization' => "Bearer #{allowed_app.app.api_jwt}") }
    context 'valid refresh token' do
      let(:allowed_app) { create(:allowed_app) }
      let(:refresh_token) { JwtRefreshResponseGenerator.new(allowed_app).call[:refresh_token] }
      it 'returns http success' do
        post :refresh, params: { auth: { refresh_token: refresh_token } }
        expect(response).to have_http_status(:success)
      end
    end

    context 'invalid refresh token' do
      let(:allowed_app) { create(:allowed_app) }
      let(:refresh_token) { JwtRefreshResponseGenerator.new(allowed_app).call[:refresh_token] }
      let(:invalid_refresh_token) { 'invalid_refresh_token' }
      it 'returns http bad_request' do
        post :refresh, params: { auth: { refresh_token: invalid_refresh_token } }
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'refresh token for other app' do
      let(:allowed_app) { create(:allowed_app) }
      let(:allowed_app_other) { create(:allowed_app) }
      let(:refresh_token) { JwtRefreshResponseGenerator.new(allowed_app).call[:refresh_token] }
      let(:invalid_refresh_token) { JwtRefreshResponseGenerator.new(allowed_app_other).call[:refresh_token] }
      it 'returns http bad_request' do
        post :refresh, params: { auth: { refresh_token: invalid_refresh_token } }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'POST #valid' do
    before { request.headers.merge!('Authorization' => "Bearer #{allowed_app.app.api_jwt}") }
    context 'valid token' do
      let(:allowed_app) { create(:allowed_app) }
      let(:jwt_token) { JwtRefreshResponseGenerator.new(allowed_app).call[:jwt] }
      it 'returns http success' do
        post :valid, params: { auth: { jwt: jwt_token } }
        expect(response).to have_http_status(:success)
      end
    end

    context 'invalid token' do
      let(:allowed_app) { create(:allowed_app) }
      let(:jwt_token) { 'error' + JwtRefreshResponseGenerator.new(allowed_app).call[:jwt] }
      it 'returns http unauthorized Unknown error' do
        post :valid, params: { auth: { jwt: jwt_token } }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq('error' => 'Unknown error')
      end
    end

    context 'token from other user' do
      let(:allowed_app) { create(:allowed_app) }
      let(:allowed_app_invalid) { create(:allowed_app) }
      let(:jwt_token) { JwtRefreshResponseGenerator.new(allowed_app_invalid).call[:jwt] }
      it 'returns http unauthorized Verification Signature Fail' do
        post :valid, params: { auth: { jwt: jwt_token } }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to eq('error' => 'Verification Signature Fail')
      end
    end
  end

  describe 'GET #public_key' do
    before { request.headers.merge!('Authorization' => "Bearer #{app.api_jwt}") }
    let(:app) { create(:app) }
    context 'valid app id' do
      it 'returns http success' do
        get :public_key
        expect(response).to have_http_status(:success)
      end

      it 'returns the app public key' do
        get :public_key
        expect(JSON.parse(response.body)['public_key']).to eq app.rsa_public_key
      end
    end

    context 'using api_jwt from inexistent app' do
      let(:invalid_api_jwt) { JsonWebToken.encode(app_id: 0) }
      it 'returns http unauthorized' do
        request.headers.merge!('Authorization' => "Bearer #{invalid_api_jwt}")
        get :public_key
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'using invalid api_jwt' do
      let(:invalid_api_jwt) { 'invalid.jwt' }
      it 'returns http unauthorized' do
        request.headers.merge!('Authorization' => "Bearer #{invalid_api_jwt}")
        get :public_key
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'using api_jwt signed with invalid secret' do
      let(:allowed_app) { create(:allowed_app) }
      let(:invalid_secret) { 'invalid_secret' }
      it 'returns http unauthorized' do
        request.headers.merge!('Authorization' => "Bearer #{JWT.encode({ app_id: allowed_app.app.id }, invalid_secret)}")
        get :public_key
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  private

  def decoded_jwt(response, allowed_app)
    rsa_public_key = OpenSSL::PKey::RSA.new allowed_app.app.rsa_public_key
    JsonWebToken.decode(JSON.parse(response.body)['jwt'], rsa_public_key)
  end
end
