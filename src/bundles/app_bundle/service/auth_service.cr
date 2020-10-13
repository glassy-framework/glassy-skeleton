require "jwt"
require "glassy-i18n"
require "../model/user"
require "../repository/user_repository"
require "../service/crypt_service"
require "../exception/validation_exception"

module App
  class AuthService
    def initialize(
      @user_repository : UserRepository,
      @crypt_service : CryptService,
      @app_secret : String,
      @i18n : Glassy::I18n::Translator
    )
    end

    def login(email : String, password : String)
      user = @user_repository.find_one_by({"email" => email})

      if user.nil?
        raise ValidationException.new(@i18n.t("email_not_found"))
      end

      unless @crypt_service.cmp_hash(user.password.to_s, password)
        raise ValidationException.new(@i18n.t("incorrect_password"))
      end

      login_user(user)
    end

    def login_user(user : User)
      {
        user:          user,
        access_token:  generate_access_token(user.id.to_s),
        refresh_token: generate_refresh_token(user.id.to_s),
        ttl:           get_access_ttl,
      }
    end

    def get_user_id(access_token : String) : String
      begin
        payload, header = JWT.decode(access_token, @app_secret, JWT::Algorithm::HS256)
      rescue JWT::ExpiredSignatureError
        raise ValidationException.new(@i18n.t("errors.expired_access_token"))
      rescue
        raise ValidationException.new(@i18n.t("errors.invalid_access_token"))
      end

      if payload["type"] != "access"
        raise ValidationException.new(@i18n.t("errors.invalid_token_type"))
      end

      payload["sub"].to_s
    end

    def refresh(refresh_token : String)
      begin
        payload, header = JWT.decode(refresh_token, @app_secret, JWT::Algorithm::HS256)
      rescue
        raise ValidationException.new(@i18n.t("errors.invalid_refresh_token"))
      end

      if payload["type"] != "refresh"
        raise ValidationException.new(@i18n.t("errors.invalid_token_type"))
      end

      {
        access_token:  generate_access_token(payload["sub"].to_s),
        refresh_token: generate_refresh_token(payload["sub"].to_s),
        ttl:           get_access_ttl,
      }
    end

    def generate_access_token(user_id : String) : String
      JWT.encode({
        "sub"  => user_id,
        "type" => "access",
        "exp"  => Time.utc.to_unix + get_access_ttl,
      }, @app_secret, JWT::Algorithm::HS256)
    end

    def generate_refresh_token(user_id : String) : String
      JWT.encode({
        "sub"  => user_id,
        "type" => "refresh",
        "exp"  => Time.utc.to_unix + get_refresh_ttl,
      }, @app_secret, JWT::Algorithm::HS256)
    end

    def get_access_ttl : Int32
      60 * 5 # 5 minutes
    end

    def get_refresh_ttl : Int32
      60 * 60 * 24 * 3 # 3 days
    end
  end
end
