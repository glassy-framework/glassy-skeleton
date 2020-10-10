require "spec-kemal"
require "spec"
require "dotenv"
require "../src/app_kernel"

Dotenv.load "#{__DIR__}/../.env.test"

Kemal.config.env = "test"
Kemal.config.port = 3030

kernel = AppKernel.new

http_kernel = kernel.container.http_kernel
http_kernel.register_controllers(kernel.container.http_controller_builder_list)
http_kernel.register_middlewares(kernel.container.http_middleware_list)
http_kernel.run

Spec.before_each do
  conn = kernel.container.db_connection
  conn.client[kernel.container.config.get("db.default_database").not_nil!].drop
end

def post_json(path : String, body : String, headers : HTTP::Headers? = nil)
  headers ||= HTTP::Headers.new
  headers["Content-Type"] = "application/json"

  post path, headers, body
end
