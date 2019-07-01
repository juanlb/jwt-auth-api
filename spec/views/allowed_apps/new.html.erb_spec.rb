require 'rails_helper'

RSpec.describe "allowed_apps/new", type: :view do
  before(:each) do
    assign(:allowed_app, AllowedApp.new(
      :permissions => "MyString"
    ))
  end

  it "renders new allowed_app form" do
    render

    assert_select "form[action=?][method=?]", allowed_apps_path, "post" do

      assert_select "input[name=?]", "allowed_app[permissions]"
    end
  end
end
