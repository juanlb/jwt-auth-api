require 'rails_helper'

RSpec.describe "allowed_apps/edit", type: :view do
  let(:allowed_app) { FactoryBot.create(:allowed_app)}

  before(:each) do
    @allowed_app = allowed_app
    @user = allowed_app.user
  end

  it "renders the edit allowed_app form" do
    render

    assert_select "form[action=?][method=?]", user_allowed_app_path(@user, allowed_app), "post" do

      assert_select "input[name=?]", "allowed_app[permissions]"
    end
  end
end
