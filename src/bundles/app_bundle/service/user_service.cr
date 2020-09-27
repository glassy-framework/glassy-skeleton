require "../autoload"

module App
  class UserService
    def initialize(@user_repository : UserRepository, @crypt_service : CryptService)
    end

    def signup(user : User, password : String) : User
      if user.email.empty?
        raise ValidationException.new("Email can't be empty")
      end

      if user.name.empty?
        raise ValidationException.new("Name can't be empty")
      end

      if password.empty?
        raise ValidationException.new("Password can't be empty")
      end

      existing_user = @user_repository.find_one_by({"email" => user.email})

      unless existing_user.nil?
        raise ValidationException.new("E-mail already exists")
      end

      user.password = @crypt_service.hash(password)

      @user_repository.save(user)

      user
    end
  end
end
