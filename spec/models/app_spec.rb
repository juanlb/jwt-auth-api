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

  describe 'Uniqueness validations' do
    subject{build(:app)}
    it { should validate_uniqueness_of(:name) }
  end

  describe '#create' do
    let!(:name) {'App Name'}

    context 'with a "App Name" name' do
      subject do
        create(:app, name: name)
      end

      it 'set app-name-NUMBERS at app_key' do
        expect(subject.app_key).to start_with('app-name-')
      end

      it 'jwt_secret be something' do
        expect(subject.jwt_secret).not_to be_empty
      end
    end
  end
end
