require 'rails_helper'

RSpec.describe "allowed_apps/index_app", type: :view do
  let(:allowed_app_index) { FactoryBot.create(:allowed_app, permissions: '{"active": "true", "quantity": 1, "code": "abcd"}') }
  let(:allowed_app) { AllowedApp.new }

  before(:each) do
    @allowed_app = allowed_app
    @app = allowed_app_index.app
  end

  it "renders a list of allowed_apps" do
    render
    assert_select "tr>td",  {"active":"true","quantity":1,"code":"abcd"} , :count => 1
  end
end
