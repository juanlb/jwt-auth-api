require 'rails_helper'

RSpec.describe "allowed_apps/index", type: :view do
  let(:allowed_app) { FactoryBot.create(:allowed_app, permissions: 'Permissions') }

  before(:each) do
    @allowed_app = allowed_app
    @user = allowed_app.user
    @available_apps = App.where.not(id: @user.apps)
  end

  it "renders a list of allowed_apps" do
    render
    assert_select "tr>td", :text => "Permissions".to_s, :count => 1
  end
end
