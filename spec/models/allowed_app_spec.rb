# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AllowedApp, type: :model do
  describe 'Factory' do
    it 'has a valid factory' do
      expect(create(:allowed_app)).to be_valid
    end
  end

  describe 'associations' do
    it { should belong_to(:app) }
    it { should belong_to(:user) }
    it { should have_one(:refresh_token).dependent(:destroy) }
  end

  describe 'Uniqueness validations with app' do
    let(:app_new) { create(:app) }
    let(:user_new) { create(:user) }
    let!(:allowed_app) { create(:allowed_app, app: app_new, user: user_new) }
    let(:duplicated_allowed_app) { create(:allowed_app, app: app_new, user: user_new) }

    it 'cant create a duplicate' do
      expect { duplicated_allowed_app }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe '.create' do
    context 'with invalid permissions' do
      subject { create(:allowed_app, permissions: '{"invalid": "parameters"}') }
      it 'is created, no schema validation on create' do
        expect { subject }.to change(AllowedApp, :count).by(1)
      end
    end

    context 'with app with nil permissions' do
      let(:app) { create(:app, permissions: '{}') }
      subject { create(:allowed_app, app: app, permissions: nil) }
      it 'is created, no schema validation on create' do
        expect { subject }.to change(AllowedApp, :count).by(1)
      end
    end
  end

  describe '#permissions_valid?' do
    context 'with valid permissions' do
      let(:allowed_app) {create(:allowed_app)}
      it 'returns true' do
        expect(allowed_app.permissions_valid?).to be true
      end
    end
    context 'with valid permissions' do
      let(:allowed_app) {create(:allowed_app, permissions: '{}')}
      it 'returns true' do
        expect(allowed_app.permissions_valid?).to be false
      end
    end
  end

  describe '#need_suggestion?' do
    context 'witn valid permissions' do
      subject{create(:allowed_app).need_suggestion?}
      it 'return false' do
        expect(subject).to be false
      end
    end

    context 'witn invalid and empty permissions' do
      subject{create(:allowed_app, permissions: '{}').need_suggestion?}
      it 'return true' do
        expect(subject).to be true
      end
    end
  end
end
