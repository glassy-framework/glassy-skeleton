require "crypto/bcrypt/password"

module App
  class CryptService
    def hash(password : String) : String
      Crypto::Bcrypt::Password.create(password).to_s
    end

    def cmp_hash(crypted_hash : String, not_crypted_hash : String) : Bool
      password = Crypto::Bcrypt::Password.new(crypted_hash)
      password.verify(not_crypted_hash)
    end
  end
end
