require 'rails_helper'

RSpec.describe "allowed_apps/edit", type: :view do
  before(:each) do
    @allowed_app = assign(:allowed_app, AllowedApp.create!(
      :permissions => "MyString"
    ))
  end

  it "renders the edit allowed_app form" do
    render

    assert_select "form[action=?][method=?]", allowed_app_path(@allowed_app), "post" do

      assert_select "input[name=?]", "allowed_app[permissions]"
    end
  end
end
