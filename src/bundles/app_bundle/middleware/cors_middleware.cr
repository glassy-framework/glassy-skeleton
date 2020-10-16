require "http/server"
require "glassy-http"
require "../service/cors_service"

module App
  class CorsMiddleware < Glassy::HTTP::Middleware
    def initialize(@cors_service : CorsService)
    end

    def call(ctx : HTTP::Server::Context)
      @cors_service.apply_headers(ctx)
      call_next(ctx)
    end
  end
end
