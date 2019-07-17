# frozen_string_literal: true

class RsaKeyManager
  def create
    rsa_private = OpenSSL::PKey::RSA.generate 2048
    rsa_public = rsa_private.public_key
    {
      rsa_private: rsa_private.export(cipher, pass_phrase),
      rsa_public: rsa_public.export
    }
  end

  def load(rsa_private_key)
    OpenSSL::PKey::RSA.new rsa_private_key, pass_phrase
  end

  private

  def pass_phrase
    ENV.fetch('JWT_PASS_PHRASE') { 'asdf' }
  end

  def cipher
    OpenSSL::Cipher::AES.new(128, :CBC)
  end
end
