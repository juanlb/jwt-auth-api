require 'rails_helper'

RSpec.describe AllowedAppsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # AllowedApp. As you add validations to AllowedApp, be sure to
  # adjust the attributes here as well.
  let(:user) {FactoryBot.create(:user)}
  let(:app)  {FactoryBot.create(:app)}
  let(:valid_attributes) {
    {user_id: user.id, app_id: app.id, permissions: {}}
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # AllowedAppsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "returns a success response" do
      AllowedApp.create! valid_attributes
      get :index, params: {user_id: user.id}, session: valid_session
      response.should render_template("index")

    end
  end

  describe "GET #show" do
    it "returns a success response" do
      allowed_app = AllowedApp.create! valid_attributes
      get :show, params: {id: allowed_app.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      allowed_app = AllowedApp.create! valid_attributes
      get :edit, params: {id: allowed_app.to_param}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new AllowedApp" do
        expect {
          post :create, params: {allowed_app: valid_attributes}, session: valid_session
        }.to change(AllowedApp, :count).by(1)
      end

      it "redirects to the created allowed_app" do
        post :create, params: {allowed_app: valid_attributes}, session: valid_session
        expect(response).to redirect_to(AllowedApp.last)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'new' template)" do
        post :create, params: {allowed_app: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested allowed_app" do
        allowed_app = AllowedApp.create! valid_attributes
        put :update, params: {id: allowed_app.to_param, allowed_app: new_attributes}, session: valid_session
        allowed_app.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the allowed_app" do
        allowed_app = AllowedApp.create! valid_attributes
        put :update, params: {id: allowed_app.to_param, allowed_app: valid_attributes}, session: valid_session
        expect(response).to redirect_to(allowed_app)
      end
    end

    context "with invalid params" do
      it "returns a success response (i.e. to display the 'edit' template)" do
        allowed_app = AllowedApp.create! valid_attributes
        put :update, params: {id: allowed_app.to_param, allowed_app: invalid_attributes}, session: valid_session
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested allowed_app" do
      allowed_app = AllowedApp.create! valid_attributes
      expect {
        delete :destroy, params: {id: allowed_app.to_param}, session: valid_session
      }.to change(AllowedApp, :count).by(-1)
    end

    it "redirects to the allowed_apps list" do
      allowed_app = AllowedApp.create! valid_attributes
      delete :destroy, params: {id: allowed_app.to_param}, session: valid_session
      expect(response).to redirect_to(allowed_apps_url)
    end
  end

end
