# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DynamicSchema do
  describe '.new' do
    context 'with no JSON param' do
      let(:no_json) { 'not a JSON' }
      subject { DynamicSchema.new(no_json) }
      it 'raise a JSON parse error exeption' do
        expect { subject }.to raise_error(/unexpected token/)
      end
    end
  end

  describe '#call' do
    context 'with valid input' do
      let(:permission_json) { '{"active": ["true", "false"], "quantity": "integer", "code": "string"}' }
      subject { DynamicSchema.new(permission_json).call }
      it 'return a valid JSON schema' do
        expect(subject).to eq(required: %w[active quantity code], additionalProperties: false, properties: { active: { enum: %w[true false], type: 'string' }, code: { type: 'string' }, malformed_json: { not: {} }, quantity: { type: 'integer' } }, type: 'object')
      end
    end
    context 'with {} input' do
      let(:permission_json) { '{}' }
      subject { DynamicSchema.new(permission_json).call }
      it 'return a valid JSON schema without properties' do
        expect(subject).to eq(required: [], additionalProperties: false, properties: { malformed_json: { not: {} } }, type: 'object')
      end
    end
    context 'with nil input' do
      let(:permission_json) { nil }
      subject { DynamicSchema.new(permission_json).call }
      it 'return a valid JSON schema' do
        expect { subject }.to raise_error(/no implicit conversion of nil into String/)
      end
    end
  end
end
