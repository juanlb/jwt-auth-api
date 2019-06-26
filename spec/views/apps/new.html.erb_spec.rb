require 'rails_helper'

RSpec.describe "apps/new", type: :view do
  before(:each) do
    assign(:app, App.new(
      :name => "MyString",
      :app_key => "MyString",
      :permissions => '{"key1": ["value1", "value2"], "key2": ["value1", "value2"]}',
      :jwt_secret => "MyString",
      :timeout => 1
    ))
  end

  it "renders new app form" do
    render

    assert_select "form[action=?][method=?]", apps_path, "post" do

      assert_select "input[name=?]", "app[name]"

      assert_select "textarea[name=?]", "app[permissions]"

      assert_select "input[name=?]", "app[timeout]"
    end
  end
end
