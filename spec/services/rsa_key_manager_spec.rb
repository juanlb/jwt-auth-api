# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RsaKeyManager do
    describe '#create' do
        subject{RsaKeyManager.new.create}
        context 'normal use' do
            it 'returns a RSA 256 key pair' do
                expect(subject).to have_key(:rsa_private)
                expect(subject).to have_key(:rsa_public)
            end
        end
    end

    describe '#load' do
        subject{RsaKeyManager.new.load(jwt_rsa_private_key)}

        context 'normal use' do
            let(:jwt_rsa_private_key) {RsaKeyManager.new.create[:rsa_private]}
            it 'returns a OpenSSL::PKey::RSA' do
                expect(subject.class).to be OpenSSL::PKey::RSA
            end
        end

        context 'encrypt and decrypt' do
            let(:key_pair) {RsaKeyManager.new.create}
            let(:jwt_rsa_private_key) { key_pair[:rsa_private]}
            let(:string_to_encrypt) { 'life is good' }
            it 'decrypt correct' do
                decrypter = OpenSSL::PKey::RSA.new key_pair[:rsa_public], pass_phrase
                encrypted_text = subject.private_encrypt(string_to_encrypt)
                expect(decrypter.public_decrypt(encrypted_text)).to eq string_to_encrypt
            end
        end

        context 'invalid rsa private key' do
            let(:jwt_rsa_private_key) { '-----BEGIN RSA PRIVATE KEY----- invalid data'}
            it 'returns a OpenSSL::PKey::RSA' do
                expect { subject }.to raise_error(/Neither PUB key nor PRIV key/)
            end
        end
    end

    private

    def pass_phrase
      ENV.fetch('JWT_PASS_PHRASE') { 'asdf' }
    end

end