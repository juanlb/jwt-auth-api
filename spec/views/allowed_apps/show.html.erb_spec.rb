require 'rails_helper'

RSpec.describe "allowed_apps/show", type: :view do
  before(:each) do
    @allowed_app = assign(:allowed_app, AllowedApp.create!(
      :permissions => "Permissions"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Permissions/)
  end
end
