class SecretMaker
    def self.generate(size = nil)
        SecureRandom.hex(64)[0..size]
    end
end