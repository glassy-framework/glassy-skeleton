require "crypto/bcrypt/password"

module App
  class CryptService
    def initialize(@app_secret : String)
    end

    def salt
      "_salt_#{@app_secret}"
    end

    def hash(password : String) : String
      Crypto::Bcrypt::Password.create(password + salt).to_s
    end

    def cmp_hash(crypted_hash : String, not_crypted_hash : String) : Bool
      password = Crypto::Bcrypt::Password.new(crypted_hash)
      password.verify(not_crypted_hash + salt)
    end
  end
end
