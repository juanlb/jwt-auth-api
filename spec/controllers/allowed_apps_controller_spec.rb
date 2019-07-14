# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AllowedAppsController, type: :controller do
  login_admin
  # This should return the minimal set of attributes required to create a valid
  # AllowedApp. As you add validations to AllowedApp, be sure to
  # adjust the attributes here as well.
  let(:user) { FactoryBot.create(:user) }
  let(:app)  { FactoryBot.create(:app) }
  let(:valid_attributes) do
    { user_id: user.id, app_id: app.id, permissions: '{"role": "admin", "enabled": true, "quantity": 1, "code": "1234"}' }
  end

  let(:invalid_attributes) do
    { user_id: user.id, app_id: app.id, permissions: '{"invalid": "parameters"}' }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # AllowedAppsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index_user' do
    it 'returns a success response' do
      AllowedApp.create! valid_attributes
      get :index_user, params: { user_id: user.id }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #index_app' do
    it 'returns a success response' do
      AllowedApp.create! valid_attributes
      get :index_app, params: { app_id: app.id }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      allowed_app = AllowedApp.create! valid_attributes
      get :show, params: { user_id: user.id, id: allowed_app.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      allowed_app = AllowedApp.create! valid_attributes
      get :edit, params: { user_id: user.id, id: allowed_app.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new AllowedApp' do
        expect do
          post :create, params: { user_id: user.id, allowed_app: valid_attributes }, session: valid_session
        end.to change(AllowedApp, :count).by(1)
      end

      it 'redirects to the created allowed_app' do
        post :create, params: { user_id: user.id, allowed_app: valid_attributes }, session: valid_session
        expect(response).to redirect_to(user_allowed_apps_path(user))
      end
    end

    context 'with invalid permission param' do
      it 'returns a success response, no check JSON Schema at create' do
        post :create, params: { user_id: user.id, allowed_app: invalid_attributes }, session: valid_session
        expect(response).to redirect_to(user_allowed_apps_path(user))
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { user_id: user.id, app_id: app.id, permissions: '{"role": "user", "quantity": 2, "code": "abcd", "enabled": false}' }
      end

      it 'updates the requested allowed_app' do
        allowed_app = AllowedApp.create! valid_attributes
        put :update, params: { user_id: user.id, id: allowed_app.to_param, allowed_app: new_attributes }, session: valid_session
        allowed_app.reload
        expect(allowed_app.permissions).to eq('{"role":"user","quantity":2,"code":"abcd","enabled":false}')
      end

      it 'redirects to the allowed_app' do
        allowed_app = AllowedApp.create! valid_attributes
        put :update, params: { user_id: user.id, id: allowed_app.to_param, allowed_app: valid_attributes }, session: valid_session
        expect(response).to redirect_to(allowed_app_path(allowed_app))
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'edit' template)" do
        allowed_app = AllowedApp.create! valid_attributes
        put :update, params: { user_id: user.id, id: allowed_app.to_param, allowed_app: invalid_attributes }, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested allowed_app' do
      allowed_app = AllowedApp.create! valid_attributes
      expect do
        delete :destroy, params: { user_id: user.id, id: allowed_app.to_param }, session: valid_session
      end.to change(AllowedApp, :count).by(-1)
    end

    it 'redirects to the allowed_apps list' do
      allowed_app = AllowedApp.create! valid_attributes
      delete :destroy, params: { user_id: user.id, id: allowed_app.to_param }, session: valid_session
      expect(response).to redirect_to(root_path)
    end

    context 'test with redirect back' do
      let(:back) { 'http://google.com' }
      before { request.env['HTTP_REFERER'] = back }
      it 'redirects to the allowed_apps list' do
        allowed_app = AllowedApp.create! valid_attributes
        delete :destroy, params: { user_id: user.id, id: allowed_app.to_param }, session: valid_session
        expect(response).to redirect_to(back)
      end
    end
  end
end
