require 'rails_helper'

RSpec.describe "apps/show", type: :view do
  before(:each) do
    @app = assign(:app, App.create!(
      :name => "Name",
      :app_key => "App Key",
      :permissions => "Permissions",
      :jwt_secret => "Jwt Secret",
      :timeout => 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Permissions/)
    expect(rendered).to match(/2/)
  end
end
