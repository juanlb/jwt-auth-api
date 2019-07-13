# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'allowed_apps/edit', type: :view do

  context 'valid allowed app' do
    let(:allowed_app) { FactoryBot.create(:allowed_app) }

    before(:each) do
      @allowed_app = allowed_app
      @user = allowed_app.user
    end

    it 'renders the edit allowed_app form' do
      render

      assert_select 'form[action=?][method=?]', user_allowed_app_path(@user, allowed_app), 'post' do
        assert_select 'textarea[name=?]', 'allowed_app[permissions]'
        assert_select "strong",  text: '(Automatic Suggestion)' , :count => 0
      end
    end
  end

  context 'invalid allowed app' do
    let(:allowed_app) { FactoryBot.create(:allowed_app, permissions: '{}') }

    before(:each) do
      @allowed_app = allowed_app
      @user = allowed_app.user
    end

    it 'renders the edit allowed_app form' do
      render

      assert_select 'form[action=?][method=?]', user_allowed_app_path(@user, allowed_app), 'post' do
        assert_select 'textarea[name=?]', 'allowed_app[permissions]'
        assert_select "strong",  text: '(Automatic Suggestion)' , :count => 1
      end
    end
  end

end
