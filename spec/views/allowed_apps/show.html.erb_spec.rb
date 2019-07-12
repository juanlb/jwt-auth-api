require 'rails_helper'

RSpec.describe "allowed_apps/show", type: :view do
  let(:allowed_app) { FactoryBot.create(:allowed_app, permissions: '{"active": "true", "quantity": 1, "code": "abcd"}') }

  before(:each) do
    @allowed_app = allowed_app
    @user = allowed_app.user
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/active/)
  end
end
