require 'rails_helper'

RSpec.describe "allowed_apps/index", type: :view do
  before(:each) do
    assign(:allowed_apps, [
      AllowedApp.create!(
        :permissions => "Permissions"
      ),
      AllowedApp.create!(
        :permissions => "Permissions"
      )
    ])
  end

  it "renders a list of allowed_apps" do
    render
    assert_select "tr>td", :text => "Permissions".to_s, :count => 2
  end
end
