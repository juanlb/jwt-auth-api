# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JwtInputValidator do
  describe '#get_allowed_app' do
    subject { JwtInputValidator.new(params, app).get_allowed_app }
    let(:allowed_app) { create(:allowed_app) }
    let(:app) { allowed_app.app }
    context 'with nil params' do
      let(:params) { nil }
      it 'returns nil' do
        expect(subject).to be nil
      end
    end

    context 'with empty hash params params' do
      let(:params) { {} }
      it 'returns nil' do
        expect(subject).to be nil
      end
    end

    context 'with valid params for user_key' do
      let(:params) { { user_key: allowed_app.user.user_key } }
      it 'returns allowed_app' do
        expect(subject).to eq allowed_app
      end
    end

    context 'with valid params for email and pass' do
      let(:valid_pass) { 'valid_pass' }
      let(:params) { { email: allowed_app.user.email, password: valid_pass } }
      it 'returns allowed_app' do
        allowed_app.user.password = valid_pass
        allowed_app.user.save
        expect(subject).to eq allowed_app
      end
    end

    context 'with invalid params for user_key' do
      let(:params) { { user_key: 'invalid_user_key' } }
      it 'returns nil' do
        expect(subject).to eq nil
      end
    end

    context 'with valid params for email and pass' do
      let(:valid_pass) { 'valid_pass' }
      let(:invalid_pass) { 'invalid_pass' }
      let(:params) { { email: allowed_app.user.email, password: invalid_pass } }
      it 'returns nil' do
        allowed_app.user.password = valid_pass
        allowed_app.user.save
        expect(subject).to eq nil
      end
    end

    context 'with invalid params for user_key and app_key' do
      let(:params) { { user_key: 'invalid_user_key' } }
      it 'returns nil' do
        expect(subject).to eq nil
      end
    end

    context 'with invalid params for user_key' do
        let(:other_allowed_param) { create(:allowed_app)}
        let(:params) { { user_key: other_allowed_param.user.user_key } }
        it 'returns nil' do
          expect(subject).to eq nil
        end
      end

    context 'with invalid params keys' do
      let(:params) { { invalid_key: 'invalid_user_key', another_invalid_key: 'invalid_app_key' } }
      it 'returns nil' do
        expect(subject).to eq nil
      end
    end
  end
end
