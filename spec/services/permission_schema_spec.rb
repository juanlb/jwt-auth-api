# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PermissionSchema do
  describe '.new' do
    context 'with no array param' do
      let(:no_array) { 'a string' }
      subject { PermissionSchema.new(no_array) }

      it 'raise exeption' do
        expect{subject}.to raise_exception('PermissionSchema needs a Array with 2 items')
      end
    end
    context 'with array param with no 2 items' do
      let(:wrong_array) { [1,2,3] }
      subject { PermissionSchema.new(wrong_array) }

      it 'raise exeption' do
        expect{subject}.to raise_exception('PermissionSchema needs a Array with 2 items')
      end
    end
  end
end
