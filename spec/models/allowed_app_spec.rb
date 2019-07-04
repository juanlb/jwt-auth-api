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
  end

  describe 'Uniqueness validations with app' do
    let(:app_new) {create(:app)}
    let(:user_new) {create(:user)}
    let!(:allowed_app) { create(:allowed_app, app: app_new, user: user_new)}
    let(:duplicated_allowed_app) { create(:allowed_app, app: app_new, user: user_new)}

    it 'cant create a duplicate' do
      expect{ duplicated_allowed_app }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe '.create' do
    context 'with invalid permissions' do
      subject { create(:allowed_app, permissions: '{"invalid": "parameters"}')}
      it 'is created, no schema validation on create' do
        expect{subject}.to change(AllowedApp, :count).by(1)
      end
    end
  end
  
end
