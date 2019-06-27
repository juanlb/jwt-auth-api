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
end
