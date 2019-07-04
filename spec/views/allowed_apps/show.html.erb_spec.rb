require 'rails_helper'

RSpec.describe "allowed_apps/show", type: :view do
  let(:allowed_app) { FactoryBot.create(:allowed_app, permissions: '{}') }

  before(:each) do
    @allowed_app = allowed_app
    @user = allowed_app.user
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/\{\}/)
  end
end
