# frozen_string_literal: true

class SecretMaker
  def self.generate(size = nil)
    size = size.nil? ? nil : size - 1
    SecureRandom.hex(64)[0..size]
  end
end
