# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AllowedApp, type: :model do
  describe 'Factory' do
    it 'has a valid factory' do
      expect(build(:allowed_app)).to be_valid
    end
  end

  describe 'Presence validations' do
    it { should validate_presence_of(:app) }
    it { should validate_presence_of(:user) }
  end

  describe 'Uniqueness validations' do
    subject { build(:allowed_app) }
    it { should validate_uniqueness_of(:user_id).scoped_to(:app_id).with_message('only can be associated with an app once.') }
  end
end
