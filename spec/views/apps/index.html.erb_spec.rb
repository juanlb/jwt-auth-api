require 'rails_helper'

RSpec.describe "apps/index", type: :view do
  before(:each) do
    assign(:apps, [
      App.create!(
        :name => "Name",
        :app_key => "App Key",
        :permissions => "Permissions",
        :jwt_secret => "Jwt Secret",
        :tiemout => 2
      ),
      App.create!(
        :name => "Name",
        :app_key => "App Key",
        :permissions => "Permissions",
        :jwt_secret => "Jwt Secret",
        :tiemout => 2
      )
    ])
  end

  it "renders a list of apps" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "App Key".to_s, :count => 2
    assert_select "tr>td", :text => "Permissions".to_s, :count => 2
    assert_select "tr>td", :text => "Jwt Secret".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
  end
end
