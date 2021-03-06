# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SecretGenerator do
  describe '.generate' do

    context 'without param' do
        subject {SecretGenerator.generate}

        it 'returns a 128 chars secret' do
            expect(subject.length).to be(128)
        end
    end

    context 'with param of 10' do
        subject {SecretGenerator.generate(10)}

        it 'returns a 10 chars secret' do
            expect(subject.length).to be(10)
        end
    end
  end
end
