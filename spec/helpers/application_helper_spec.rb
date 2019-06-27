# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'pretty generate json' do
    let(:json) { '{"foo":"bar"}' }
    it 'pretty generat json' do
      expect(helper.json_pretty_generate(json)).to eq("{\n  \"foo\": \"bar\"\n}")
    end
  end
end
