require "./app_kernel"
require "dotenv"

Dotenv.load ".env"

kernel = AppKernel.new

options "/*" do |env|
  kernel.container.app_cors_service.apply_headers(env)
  halt env, 200
end

kernel.container.console_app.run(ARGV)
