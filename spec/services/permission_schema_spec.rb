# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PermissionSchema do
  describe '.new' do
    context 'with no array param' do
      let(:no_array) { 'a string' }
      subject { PermissionSchema.new(no_array) }

      it 'raise exeption' do
        expect { subject }.to raise_exception('PermissionSchema needs a Array with 2 items')
      end
    end
    context 'with array param with no 2 items' do
      let(:wrong_array) { [1, 2, 3] }
      subject { PermissionSchema.new(wrong_array) }

      it 'raise exeption' do
        expect { subject }.to raise_exception('PermissionSchema needs a Array with 2 items')
      end
    end
  end
  describe '#generate' do
    subject { PermissionSchema.new(array).generate }

    context 'with code string' do
      let(:array) { %w[code string] }
      it 'return valid output' do
        expect(subject).to eq code: { type: 'string' }
      end
    end

    context 'with quantity integer' do
      let(:array) { %w[quantity integer] }
      it 'return valid output' do
        expect(subject).to eq quantity: { type: 'integer' }
      end
    end

    context 'with enabled boolean' do
      let(:array) { %w[enabled boolean] }
      it 'return valid output' do
        expect(subject).to eq enabled: { type: 'boolean' }
      end
    end

    context 'with role array' do
      let(:array) { ['role', %w[user admin]] }
      it 'return valid output' do
        expect(subject).to eq role: { enum: %w[user admin], type: 'string' }
      end
    end

    context 'with invalid type' do
      let(:array) { %w[enabled sarasa] }
      it 'return valid output' do
        expect{subject}.to raise_error(/Invalid schema type/)
      end
    end
  end
  describe '#suggestion' do
    subject { PermissionSchema.new(array).suggestion }

    context 'with code string' do
      let(:array) { %w[code string] }
      it 'return valid output' do
        expect(subject).to eq code: ''
      end
    end

    context 'with quantity integer' do
      let(:array) { %w[quantity integer] }
      it 'return valid output' do
        expect(subject).to eq quantity: 0
      end
    end

    context 'with enabled boolean' do
      let(:array) { %w[enabled boolean] }
      it 'return valid output' do
        expect(subject).to eq enabled: false
      end
    end

    context 'with role array' do
      let(:array) { ['role', %w[user admin]] }
      it 'return valid output' do
        expect(subject).to eq role: 'user'
      end
    end

    context 'with invalid type' do
      let(:array) { %w[enabled sarasa] }
      it 'return valid output' do
        expect{subject}.to raise_error(/Invalid schema type/)
      end
    end
  end
end
