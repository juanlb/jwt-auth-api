# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PermissionsSuggestion do
  describe '.new' do
    context 'with no JSON param' do
      let(:no_json) { 'not a JSON' }
      subject { PermissionsSuggestion.new(no_json) }
      it 'raise a JSON parse error exeption' do
        expect { subject }.to raise_error(/unexpected token/)
      end
    end
  end

  describe '#call' do
    context 'with valid input' do
      let(:permission_json) { '{"active": ["true", "false"], "quantity": "integer", "code": "string", "enabled": "boolean"}' }
      subject { PermissionsSuggestion.new(permission_json).call }
      it 'return a valid JSON schema' do
        expect(subject).to eq(active: 'true', quantity: 0, code: '', enabled: false)
      end
    end
    context 'with {} input' do
      let(:permission_json) { '{}' }
      subject { PermissionsSuggestion.new(permission_json).call }
      it 'return a valid JSON schema without properties' do
        expect(subject).to eq({})
      end
    end
    context 'with nil input' do
      let(:permission_json) { nil }
      subject { PermissionsSuggestion.new(permission_json).call }
      it 'return a valid JSON schema' do
        expect { subject }.to raise_error(/no implicit conversion of nil into String/)
      end
    end
  end
end