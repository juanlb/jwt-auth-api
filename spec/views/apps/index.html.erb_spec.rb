# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'apps/index', type: :view do
  before(:each) do
    assign(:apps, [
             App.create!(
               name: 'Name',
               permissions: '{"key1": ["value1", "value2"], "key2": ["value1", "value2"]}',
               timeout: 2
             ),
             App.create!(
               name: 'Name2',
               permissions: '{"key1": ["value1", "value2"], "key2": ["value1", "value2"]}',
               timeout: 2
             )
           ])
  end

  it 'renders a list of apps' do
    render
    assert_select 'tr>td', text: 'Name'.to_s, count: 1
    assert_select 'tr>td', text: 'Name2'.to_s, count: 1
    assert_select 'tr>td', text: /value1/, count: 2
    assert_select 'tr>td', text: /value2/, count: 2
    assert_select 'tr>td', text: 2.to_s, count: 2
  end
end
