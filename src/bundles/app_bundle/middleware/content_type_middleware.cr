require "http/server"
require "glassy-http"

module App
  class ContentTypeMiddleware < Glassy::HTTP::Middleware
    def call(ctx : HTTP::Server::Context)
      ctx.response.content_type = "application/json"
      call_next(ctx)
    end
  end
end
