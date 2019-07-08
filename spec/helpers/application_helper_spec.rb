# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#json_pretty_generate' do
    let(:json) { '{"foo":"bar"}' }
    it 'pretty generat json' do
      expect(helper.json_pretty_generate(json)).to eq("{\n  \"foo\": \"bar\"\n}")
    end
  end

  describe '#class_active' do
    let(:controller_name) { 'users' }
    it 'create the active class' do
      controller.params[:controller] = 'users'
      expect(helper.class_active(controller_name)).to eq('class="active"')
    end
  end

  describe '#permission_state' do
    skip('permission_state')
  end

  describe '#permission_states' do
    skip('permission_states')
  end

  describe '#enabled_icon' do
    skip('enabled_icon')
  end
end
