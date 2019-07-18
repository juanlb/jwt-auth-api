# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AppsController, type: :controller do
  login_admin
  # This should return the minimal set of attributes required to create a valid
  # App. As you add validations to App, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    { name: 'Buscador', timeout: 3600 }
  end

  let(:invalid_attributes) do
    { name: nil }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # AppsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe 'GET #index' do
    it 'returns a success response' do
      App.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      app = App.create! valid_attributes
      get :show, params: { id: app.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #new' do
    it 'returns a success response' do
      get :new, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'GET #edit' do
    it 'returns a success response' do
      app = App.create! valid_attributes
      get :edit, params: { id: app.to_param }, session: valid_session
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new App' do
        expect do
          post :create, params: { app: valid_attributes }, session: valid_session
        end.to change(App, :count).by(1)
      end

      it 'redirects to the created app' do
        post :create, params: { app: valid_attributes }, session: valid_session
        expect(response).to redirect_to(App.last)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: { app: invalid_attributes }, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:new_attributes) do
        { name: 'New Name', timeout: 3601 }
      end

      it 'updates the requested app' do
        app = App.create! valid_attributes
        put :update, params: { id: app.to_param, app: new_attributes }, session: valid_session
        app.reload
        expect(app.name).to eq 'New Name'
        expect(app.timeout).to eq 3601
      end

      it 'redirects to the app' do
        app = App.create! valid_attributes
        put :update, params: { id: app.to_param, app: valid_attributes }, session: valid_session
        expect(response).to redirect_to(app)
      end
    end

    context 'with invalid params' do
      it "returns a success response (i.e. to display the 'edit' template)" do
        app = App.create! valid_attributes
        put :update, params: { id: app.to_param, app: invalid_attributes }, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'App without related user' do
      it 'destroys the requested app' do
        app = App.create! valid_attributes
        expect do
          delete :destroy, params: { id: app.to_param }, session: valid_session
        end.to change(App, :count).by(-1)
      end

      it 'redirects to the apps list' do
        app = App.create! valid_attributes
        delete :destroy, params: { id: app.to_param }, session: valid_session
        expect(response).to redirect_to(apps_url)
      end
    end

    context 'App with related user' do
      let!(:allowed_app) {create(:allowed_app)}
      it 'dont destroys the requested app' do
        expect do
          delete :destroy, params: { id: allowed_app.app.to_param }, session: valid_session
        end.not_to change(App, :count)
      end
    end
  end

  describe 'GET #reset_app_key' do
    it 'changes the app key' do
      app = App.create! valid_attributes
      expect do
        get :reset_app_key, params: { id: app.to_param }, session: valid_session
      end.to change { app.reload.app_key }
    end
  end

  describe 'GET #reset_rsa_key_pair' do
    it 'changes the rsa_private_key' do
      app = App.create! valid_attributes
      expect do
        get :reset_rsa_key_pair, params: { id: app.to_param }, session: valid_session
      end.to change { app.reload.rsa_private_key }
    end
  end
end
