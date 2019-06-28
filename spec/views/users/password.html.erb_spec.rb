# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'users/password', type: :view do
  before(:each) do
    @user = assign(:user, User.create!(
                            name: 'MyString',
                            enabled: false,
                            email: 'juanlb@gmail.com'
                          ))
  end

  it 'renders the edit password form' do
    render

    assert_select 'form[action=?][method=?]', update_password_user_path(@user), 'post' do
      assert_select 'input[name=?]', 'password'
    end
  end
end
