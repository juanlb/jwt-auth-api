# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JwtRefreshResponseGenerator do
  describe '#call' do
    subject { JwtRefreshResponseGenerator.new(allowed_app).call }

    context 'when allowed_app is nil' do
      let(:allowed_app) { nil }
      it 'returns nil' do
        expect(subject).to be nil
      end
    end

    context 'when allowed_app is valid' do
        let(:allowed_app) { create(:allowed_app) }

        it 'returns a valid refresh token' do
            expect(subject[:refresh_token]).to eq allowed_app.refresh_token.token
        end

        it 'returns valid jwt token' do
            expect(decoded_jwt(subject[:jwt], allowed_app)).to include(JSON.parse(allowed_app.permissions))
            expect(decoded_jwt(subject[:jwt], allowed_app)).to include({'permissions_valid' => allowed_app.valid?})
            expect(decoded_jwt(subject[:jwt], allowed_app)['exp']).to be_within(5).of(Time.now.to_i + allowed_app.app.timeout) 
        end
    end

    context 'when allowed_app have invalid permissions' do
        let(:allowed_app) { create(:allowed_app, permissions: '{}') }

        it 'returns a valid refresh token' do
            expect(subject[:refresh_token]).to eq allowed_app.refresh_token.token
        end

        it 'returns jwt with permissions_valid in false' do
            expect(decoded_jwt(subject[:jwt], allowed_app)).to include({'permissions_valid' => false})
        end
    end

  end

  private
  
  def algorithm(jwt_token)
    JWT.decode(jwt_token, nil, false).last['alg']
  end

  def decoded_jwt(jwt_token, allowed_app)
    rsa_public_key = OpenSSL::PKey::RSA.new allowed_app.app.jwt_rsa_public_key
    JWT.decode(jwt_token, rsa_public_key, true, {algorithm: algorithm(jwt_token)}).first
  end
end
