# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JwtChecker do
  describe '#call' do
    subject { JwtChecker.new(app, jwt).call }

    context 'valid app and jwt' do
      let(:allowed_app) { create(:allowed_app) }
      let(:app) { allowed_app.app }
      let(:jwt) { JwtRefreshResponseGenerator.new(allowed_app).call[:jwt] }
      it 'returns that jwt is valid' do
        expect(subject).to eq(response: { message: 'Valid token' }, status: :ok)
      end
    end

    context 'valid app and expired jwt' do
        let(:jwt_refresh_response_generator) {JwtRefreshResponseGenerator.new(allowed_app)}
        
        let(:allowed_app) { create(:allowed_app) }
        let(:app) { allowed_app.app }
        let(:jwt) { jwt_refresh_response_generator.call[:jwt] }
        it 'returns that jwt is valid' do
          allow(jwt_refresh_response_generator).to receive(:exp).and_return(Time.now.to_i - 1000)
          expect(subject).to eq({ response: { error: 'Expired token' }, status: :unauthorized })
        end
    end

    context 'nil app and valid jwt' do
      let(:allowed_app) { create(:allowed_app) }
      let(:app) { nil }
      let(:jwt) { JwtRefreshResponseGenerator.new(allowed_app).call[:jwt] }
      it 'returns Unknown entities' do
        expect(subject).to eq(response: { error: 'Unknown entities' }, status: :unauthorized)
      end
    end

    context 'with valid app and nil jwt' do
      let(:allowed_app) { create(:allowed_app) }
      let(:app) { allowed_app.app }
      let(:jwt) { nil }
      it 'returns Unknown entities' do
        expect(subject).to eq(response: { error: 'Unknown entities' }, status: :unauthorized)
      end
    end

    context 'wrong RSA Key' do
      let!(:allowed_app_1) { create(:allowed_app) }
      let!(:allowed_app_2) { create(:allowed_app) }
      let(:app) { allowed_app_1.app }
      let(:jwt) { JwtRefreshResponseGenerator.new(allowed_app_2).call[:jwt] }
      it 'returns Unknown entities' do
        expect(subject).to eq(response: { error: 'Verification Signature Fail' }, status: :unauthorized)
      end
    end

    context 'invalid params' do
      let(:app) { 'string' }
      let(:jwt) { 'number' }
      it 'returns Unknown error' do
        expect(subject).to eq(response: { error: 'Unknown error' }, status: :unauthorized)
      end
    end
  end
end
