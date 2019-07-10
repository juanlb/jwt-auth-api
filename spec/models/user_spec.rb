# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Factory' do
    it 'has a valid factory' do
      expect(build(:user)).to be_valid
    end
  end

  describe 'Presence validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
  end

  describe 'Uniqueness validations' do
    subject { build(:user) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_uniqueness_of(:email) }
  end

  describe 'associations' do
    it { should have_many(:allowed_apps) }
    it { should have_many(:apps).through(:allowed_apps) }
  end

  describe '#reset_user_key' do
    context 'with previous user key' do
      subject { create(:user) }

      it 'change user key' do
        expect { subject.reset_user_key }.to change { subject.reload.user_key }
      end
    end
  end

  describe '#create' do
    context 'valid params' do
      subject(:user) { create(:user) }
      it 'set user_key' do
        expect(subject.user_key).not_to be_empty
      end

      it 'set salt' do
        expect(subject.salt).not_to be_empty
      end

      it 'returns "password setted" false' do
        expect(subject.password_setted).to be false
      end
    end

    context 'invalid email' do
      subject(:user) { create(:user, email: 'not_a_mail') }
      it 'raise validation error' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe '#edit' do
    context 'edit name' do
      subject { create(:user) }

      it 'dont change jwt secret' do
        subject.name = 'otro'
        expect { subject.save }.to_not change { subject.reload.user_key }
      end
    end
  end
  describe '#edit password' do
    subject { create(:user) }
    context 'Short password' do
      let(:password) { '1234' }

      it 'raise validation error for password length' do
        subject.password = password
        expect(subject.valid?).to be false
      end

      it 'returns "password setted" false' do
        subject.password = password
        expect(subject.password_setted).to be false
      end
    end
    context 'Good password' do
      let(:password) { '12345678' }
      it 'encrypt password with salt' do
        subject.password = password
        subject.save
        expect(subject.encrypted_password).to eq BCrypt::Engine.hash_secret(password, subject.salt)
      end

      it 'returns "password setted" true' do
        subject.password = password
        expect(subject.password_setted).to be true
      end
    end
  end

  describe '#permissions_state' do
    context 'user with no relation' do
      let(:user) { create(:user) }
      it 'user returns valid 0 and invalid 0' do
        expect(user.permissions_state).to eq(invalid: 0, valid: 0)
      end
    end

    context 'user with 1 good relation' do
      let(:allowed_app) { create(:allowed_app) }
      it 'user returns valid 1 and invalid 0' do
        expect(allowed_app.user.permissions_state).to eq(invalid: 0, valid: 1)
      end
    end

    context 'user with 1 bad relation' do
      let(:allowed_app) { create(:allowed_app, permissions: '{}') }
      it 'user returns valid 0 and invalid 1' do
        expect(allowed_app.user.permissions_state).to eq(invalid: 1, valid: 0)
      end
    end

    context 'user with 1 good and 1 bad relation' do
      let!(:user) {create(:user)}
      let!(:app_1) {create(:app)}
      let!(:app_2) {create(:app)}
      let!(:allowed_app_1) {create(:allowed_app, user:user, app: app_1)}
      let!(:allowed_app_2) {create(:allowed_app, user:user, app: app_2, permissions: '{}')}
      it 'user returns valid 0 and invalid 1' do
        expect(user.permissions_state).to eq(invalid: 1, valid: 1)
      end
    end
  end
end
