require "glassy-http"
require "../autoload"

module App
  class OAuthController < Glassy::HTTP::Controller
    def initialize(@auth_service : AuthService)
    end

    @[Route("POST", "/oauth/token")]
    @[JSONBody(arg: "grant_type", path: "grant_type", required: true)]
    @[JSONBody(arg: "username", path: "username")]
    @[JSONBody(arg: "password", path: "password")]
    @[JSONBody(arg: "refresh_token", path: "refresh_token")]
    def token(grant_type : JSON::Any, username : JSON::Any?, password : JSON::Any?, refresh_token : JSON::Any?)
      grant_type = grant_type.raw.to_s

      case grant_type
      when "password"
        if username.nil? || username.not_nil!.raw.nil? || password.nil? || password.not_nil!.raw.nil?
          raise ValidationException.new("Username and password are required")
        end

        username = username.not_nil!.raw.to_s
        password = password.not_nil!.raw.to_s

        login_result = @auth_service.login(username, password)

        {
          "token_type" => "bearer",
          "access_token" => login_result[:access_token],
          "refresh_token" => login_result[:refresh_token],
          "expires_in" => login_result[:ttl],
        }.to_json
      when "refresh_token"
        if refresh_token.nil? || refresh_token.not_nil!.raw.nil?
          raise ValidationException.new("Username and password are required")
        end

        refresh_token = refresh_token.not_nil!.raw.to_s

        login_result = @auth_service.refresh(refresh_token)

        {
          "token_type" => "bearer",
          "access_token" => login_result[:access_token],
          "refresh_token" => login_result[:refresh_token],
          "expires_in" => login_result[:ttl],
        }.to_json
      else
        raise ValidationException.new("Invalid grant type")
      end
    end
  end
end
