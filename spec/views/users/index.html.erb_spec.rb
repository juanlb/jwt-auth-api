require 'rails_helper'

RSpec.describe "users/index", type: :view do
  before(:each) do
    assign(:users, [
      User.create!(
        :name => "Juan",
        :enabled => false,
        :email => "juanlb@gmail.com"
      ),
      User.create!(
        :name => "Pedro",
        :enabled => false,
        :email => "pedro@gmail.com",
      )
    ])
  end

  it "renders a list of users" do
    render
    assert_select "tr>td", :text => "Juan".to_s, :count => 1
    assert_select "tr>td", :text => "Pedro".to_s, :count => 1
    assert_select "tr>td", :text => "juanlb@gmail.com".to_s, :count => 1
    assert_select "tr>td", :text => "pedro@gmail.com".to_s, :count => 1
  end
end
