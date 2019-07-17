# frozen_string_literal: true

require 'rails_helper'

RSpec.describe App, type: :model do
  describe 'Factory' do
    it 'has a valid factory' do
      expect(build(:app)).to be_valid
    end
  end

  describe 'Presence validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:timeout) }
    it { should validate_presence_of(:app_key) }
  end

  describe 'associations' do
    it { should have_many(:allowed_apps) }
    it { should have_many(:users).through(:allowed_apps) }
  end

  describe 'Uniqueness validations' do
    subject { build(:app) }
    it { should validate_uniqueness_of(:name) }
  end

  describe '#reset_app_key' do
    context 'with previous app key' do
      subject {create(:app)}

      it 'change app key' do
        expect{subject.reset_app_key}.to change {subject.reload.app_key}
      end
    end
  end

  describe '#reset_rsa_key_pair' do
    context 'with previous jwt_secret' do
      subject {create(:app)}

      it 'change rsa_private_key' do
        expect{subject.reset_rsa_key_pair}.to change {subject.reload.rsa_private_key}
      end

      it 'change rsa_public_key' do
        expect{subject.reset_rsa_key_pair}.to change {subject.reload.rsa_public_key}
      end
    end
  end

  describe '#create' do
    let!(:name) { 'App Name' }

    context 'with a "App Name" name' do
      subject do
        create(:app, name: name)
      end

      it 'set app-name-NUMBERS at app_key' do
        expect(subject.app_key).to start_with('app-name-')
      end

      it 'rsa_private_key be something' do
        expect(subject.read_attribute(:rsa_private_key)).not_to be_empty
      end

      it 'rsa_public_key be something' do
        expect(subject.rsa_public_key).not_to be_empty
      end

      it 'permissions be an Hash' do
        expect(subject.permissions).to eq({ role: %w[admin user], quantity: 'integer', code: 'string', enabled: 'boolean' }.to_json)
      end
    end

    context 'with invalid permission json' do
      subject do
        create(:app, permissions: '{"invalid": "json"}')
      end

      it 'raise validation error' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'with malformed permission json' do
      subject do
        create(:app, permissions: 'malformed')
      end

      it 'raise validation error' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe '#edit' do
    context 'edit name' do
      subject { create(:app) }

      it 'dont change rsa_private_key' do
        subject.name = 'otro'
        expect { subject.save }.to_not change { subject.reload.read_attribute(:rsa_private_key) }
      end

      it 'dont change rsa_public_key' do
        subject.name = 'otro'
        expect { subject.save }.to_not change { subject.reload.rsa_public_key }
      end

      it 'dont change app_key' do
        subject.name = 'otro'
        expect { subject.save }.to_not change { subject.reload.app_key }
      end
    end
  end

  describe '#permissions_state' do
    context 'app with no relation' do
      let(:app) { create(:app) }
      it 'app returns valid 0 and invalid 0' do
        expect(app.permissions_state).to eq(invalid: 0, valid: 0)
      end
    end

    context 'app with 1 good relation' do
      let(:allowed_app) { create(:allowed_app) }
      it 'app returns valid 1 and invalid 0' do
        expect(allowed_app.app.permissions_state).to eq(invalid: 0, valid: 1)
      end
    end

    context 'app with 1 bad relation' do
      let(:allowed_app) { create(:allowed_app, permissions: '{}') }
      it 'app returns valid 0 and invalid 1' do
        expect(allowed_app.app.permissions_state).to eq(invalid: 1, valid: 0)
      end
    end

    context 'app with 1 good and 1 bad relation' do
      let!(:app) {create(:app)}
      let!(:user_1) {create(:user)}
      let!(:user_2) {create(:user)}
      let!(:allowed_app_1) {create(:allowed_app, user:user_1, app: app)}
      let!(:allowed_app_2) {create(:allowed_app, user:user_2, app: app, permissions: '{}')}
      it 'app returns valid 0 and invalid 1' do
        expect(app.permissions_state).to eq(invalid: 1, valid: 1)
      end
    end
  end

  describe '#rsa_private_key' do
    context 'valid private key' do
      subject{create(:app).rsa_private_key}
      it 'returns a OpenSSL::PKey::RSA' do
        expect(subject.class).to be OpenSSL::PKey::RSA
      end
    end
  end

  describe '#jwt_attributes' do
    context 'with valid app data' do
      subject{create(:app)}
      it 'return a hash with app data' do
        expect(subject.jwt_attributes).to eq({app_name: subject.name})
      end
    end
  end

end
