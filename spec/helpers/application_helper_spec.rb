# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#json_pretty_generate' do
    let(:json) { '{"foo":"bar"}' }
    it 'pretty generat json' do
      expect(helper.json_pretty_generate(json)).to eq("{\n  \"foo\": \"bar\"\n}")
    end
  end

  describe '#class_active' do
    let(:controller_name) { 'users' }
    it 'create the active class' do
      controller.params[:controller] = 'users'
      expect(helper.class_active(controller_name)).to eq('active')
    end
  end

  describe '#permission_state' do
    context 'valid permissions' do
    let(:allowed_app) {create(:allowed_app)}
      it 'draw the check icon' do
        expect(helper.permission_state(allowed_app)).to eq('<i class="fas fa-check fa-green"></i>')
      end
    end

    context 'invalid permissions' do
    let(:allowed_app) {create(:allowed_app, permissions: '{}')}
      it 'draw the cross icon' do
        expect(helper.permission_state(allowed_app)).to eq('<i class="fas fa-times fa-red"></i>')
      end
    end
  end

  describe '#show_permissions_state' do
    context 'user 0 relation' do
      let(:user) {create(:user)}
      it 'user draw 0' do
        expect(helper.show_permissions_state(user.permissions_state)).to eq('0')
      end
    end
    context 'user 1 good' do
      let(:allowed_app) {create(:allowed_app)}
      it 'draw 1 good' do
        expect(helper.show_permissions_state(allowed_app.user.permissions_state)).to eq('1 <i class="fas fa-check fa-green"></i>')
      end
    end
    context 'user 1 bad' do
      let(:allowed_app) {create(:allowed_app, permissions: '{}')}
      it 'user draw 1 bad' do
        expect(helper.show_permissions_state(allowed_app.user.permissions_state)).to eq('1 <i class="fas fa-times fa-red"></i>')
      end
    end

    context 'user 1 god, 1 bad' do
      let!(:user) {create(:user)}
      let!(:app_1) {create(:app)}
      let!(:app_2) {create(:app)}
      let!(:allowed_app_1) {create(:allowed_app, user:user, app: app_1)}
      let!(:allowed_app_2) {create(:allowed_app, user:user, app: app_2, permissions: '{}')}

      it 'user draw 1 god, 1 bad' do
        expect(helper.show_permissions_state(user.permissions_state)).to eq('1 <i class="fas fa-check fa-green"></i> - 1 <i class="fas fa-times fa-red"></i>')
      end
    end

    context 'app 0 relation' do
      let(:app) {create(:app)}
      it 'app draw 0' do
        expect(helper.show_permissions_state(app.permissions_state)).to eq('0')
      end
    end
    context 'app 1 good' do
      let(:allowed_app) {create(:allowed_app)}
      it 'draw 1 good' do
        expect(helper.show_permissions_state(allowed_app.app.permissions_state)).to eq('1 <i class="fas fa-check fa-green"></i>')
      end
    end
    context 'app 1 bad' do
      let(:allowed_app) {create(:allowed_app, permissions: '{}')}
      it 'app draw 1 bad' do
        expect(helper.show_permissions_state(allowed_app.app.permissions_state)).to eq('1 <i class="fas fa-times fa-red"></i>')
      end
    end

    context 'app 1 god, 1 bad' do
      let!(:app) {create(:app)}
      let!(:user_1) {create(:user)}
      let!(:user_2) {create(:user)}
      let!(:allowed_app_1) {create(:allowed_app, user:user_1, app: app)}
      let!(:allowed_app_2) {create(:allowed_app, user:user_2, app: app, permissions: '{}')}

      it 'app draw 1 god, 1 bad' do
        expect(helper.show_permissions_state(app.permissions_state)).to eq('1 <i class="fas fa-check fa-green"></i> - 1 <i class="fas fa-times fa-red"></i>')
      end
    end
  end

  describe '#enabled_icon' do
    context 'user enabled' do
      let(:user) { create(:user)}
      it 'draw checked icon' do
        expect(helper.enabled_icon(user.enabled)).to eq('<i class="far fa-check-square"></i>')
      end
    end
    context 'user disabled' do
      let(:user) { create(:user, enabled: false)}
      it 'draw checked icon' do
        expect(helper.enabled_icon(user.enabled)).to eq('<i class="far fa-square"></i>')
      end
    end
  end
end
