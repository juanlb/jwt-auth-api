require 'rails_helper'

RSpec.describe "apps/edit", type: :view do
  before(:each) do
    @app = assign(:app, App.create!(
      :name => "MyString",
      :app_key => "MyString",
      :permissions => "MyString",
      :jwt_secret => "MyString",
      :tiemout => 1
    ))
  end

  it "renders the edit app form" do
    render

    assert_select "form[action=?][method=?]", app_path(@app), "post" do

      assert_select "input[name=?]", "app[name]"

      assert_select "input[name=?]", "app[app_key]"

      assert_select "input[name=?]", "app[permissions]"

      assert_select "input[name=?]", "app[jwt_secret]"

      assert_select "input[name=?]", "app[tiemout]"
    end
  end
end
