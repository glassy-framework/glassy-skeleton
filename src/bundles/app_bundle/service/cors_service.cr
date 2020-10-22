require "http/server"

module App
  class CorsService
    def apply_headers(ctx : HTTP::Server::Context)
      ctx.response.headers["Access-Control-Allow-Origin"] = "*"
      ctx.response.headers["Access-Control-Allow-Methods"] = "GET, POST, PATCH, DELETE, OPTIONS"
      ctx.response.headers["Access-Control-Allow-Headers"] = "X-Requested-With, X-HTTP-Method-Override, Content-Type, Cache-Control, Accept, Authorization"
    end
  end
end
