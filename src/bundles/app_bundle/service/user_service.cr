require "glassy-i18n"
require "../model/user"
require "../exception/validation_exception"
require "../repository/user_repository"
require "../service/crypt_service"

module App
  class UserService
    def initialize(
      @user_repository : UserRepository,
      @crypt_service : CryptService,
      @i18n : Glassy::I18n::Translator
    )
    end

    def signup(user : User, password : String) : User
      if user.email.empty?
        raise ValidationException.new(@i18n.t("validation.messages.required", {
          "attr" => @i18n.t("validation.attributes.email")
        }))
      end

      if user.name.empty?
        raise ValidationException.new(@i18n.t("validation.messages.required", {
          "attr" => @i18n.t("validation.attributes.name")
        }))
      end

      if password.empty?
        raise ValidationException.new(@i18n.t("validation.messages.required", {
          "attr" => @i18n.t("validation.attributes.password")
        }))
      end

      existing_user = @user_repository.find_one_by({"email" => user.email})

      unless existing_user.nil?
        raise ValidationException.new(@i18n.t("validation.messages.email_already_exists"))
      end

      user.password = @crypt_service.hash(password)

      @user_repository.save(user)

      user
    end
  end
end
