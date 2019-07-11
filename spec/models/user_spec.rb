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
    it { should have_many(:allowed_apps).dependent(:destroy) }
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
        expect(subject.password_setted?).to be false
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
        expect(subject.password_setted?).to be false
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
        expect(subject.password_setted?).to be true
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
      let!(:user) { create(:user) }
      let!(:app_1) { create(:app) }
      let!(:app_2) { create(:app) }
      let!(:allowed_app_1) { create(:allowed_app, user: user, app: app_1) }
      let!(:allowed_app_2) { create(:allowed_app, user: user, app: app_2, permissions: '{}') }
      it 'user returns valid 0 and invalid 1' do
        expect(user.permissions_state).to eq(invalid: 1, valid: 1)
      end
    end
  end

  describe 'scope .enabled' do
    context 'two user, the second enabled' do
      let!(:user_disabled) { create(:user, enabled: false) }
      let!(:user_enabled) { create(:user) }
      it 'returns the enabled' do
        expect(User.enabled.first).to eq user_enabled
      end

      it 'returns just 1' do
        expect(User.enabled.count).to eq 1
      end
    end
  end

  describe 'scope .password_setted' do
    context 'two user, the second enabled' do
      let!(:user_without_pass) { create(:user) }
      let!(:user_with_pass) { create(:user, password: 'validpassword') }
      it 'returns the enabled' do
        expect(User.password_setted.first).to eq user_with_pass
      end

      it 'returns just 1' do
        expect(User.password_setted.count).to eq 1
      end
    end
  end

  describe '.email_with_password' do
    context 'with password setted and valid pass' do
      let(:validpass) { 'validpassword' }
      let!(:user_with_pass) { create(:user) }
      it 'returns the user' do
        user_with_pass.password = validpass
        user_with_pass.save
        expect(User.email_with_password(user_with_pass.email, validpass)).to eq user_with_pass
      end
    end

    context 'with password setted and invalid pass' do
      let(:validpass) { 'validpassword' }
      let(:invalidpass) { 'other_pass' }
      let!(:user_with_pass) { create(:user) }
      it 'returns the user' do
        user_with_pass.password = validpass
        user_with_pass.save
        expect(User.email_with_password(user_with_pass.email, invalidpass)).to eq nil
      end
    end

    context 'with password setted and incorrect user' do
      let(:validpass) { 'validpassword' }
      let(:other_mail) { 'other@mail.com' }
      let!(:user_with_pass) { create(:user) }
      it 'returns the user' do
        user_with_pass.password = validpass
        user_with_pass.save
        expect(User.email_with_password(other_mail, validpass)).to eq nil
      end
    end

    context 'with nil params' do
      let(:validpass) { 'validpassword' }
      let!(:user_with_pass) { create(:user) }
      it 'returns the user' do
        user_with_pass.password = validpass
        user_with_pass.save
        expect(User.email_with_password(nil, nil)).to eq nil
      end
    end

    context 'without password setted' do
      let(:inexistent_pass) { 'inexistent_pass' }
      let!(:user_without_pass) { create(:user) }
      it 'returns the user' do
        expect(User.email_with_password(user_without_pass.email, inexistent_pass)).to eq nil
      end
    end
  end

  describe '#jwt_attributes' do
    context 'with valid user data' do
      subject { create(:user) }
      it 'return a hash with user data' do
        expect(subject.jwt_attributes).to eq(name: subject.name, email: subject.email)
      end
    end
  end
end
