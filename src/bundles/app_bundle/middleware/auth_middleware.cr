require "http/server"
require "glassy-http"
require "../autoload"

module App
  class AuthMiddleware < Glassy::HTTP::Middleware
    def initialize(@auth_service : AuthService)
    end

    def name : String
      "auth"
    end

    def call(ctx : HTTP::Server::Context)
      return call_next(ctx) unless only_match?(ctx)

      authorization = ctx.request.headers["Authorization"]?

      if authorization.nil?
        raise Glassy::HTTP::Exceptions::UnauthorizedException.new("Authorization header is required")
      end

      access_token = authorization.not_nil!.to_s.sub("Bearer ", "")

      begin
        user_id = @auth_service.get_user_id(access_token)
      rescue e : Exception
        raise Glassy::HTTP::Exceptions::UnauthorizedException.new(e.message || "Unauthorized")
      end

      ctx.set "user_id", user_id

      call_next(ctx)
    end
  end
end
