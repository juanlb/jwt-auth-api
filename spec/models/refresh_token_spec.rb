require 'rails_helper'

RSpec.describe RefreshToken, type: :model do
  describe 'Factory' do
    it 'has a valid factory' do
      expect(create(:refresh_token)).to be_valid
    end
  end

  describe 'associations' do
    it { should belong_to(:allowed_app) }
  end

  describe 'Uniqueness validations' do
    subject { build(:refresh_token) }
    it { should validate_uniqueness_of(:allowed_app_id) }
  end
end
