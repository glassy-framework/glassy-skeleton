require "./app_kernel"
require "dotenv"

Dotenv.load ".env"

kernel = AppKernel.new
kernel.container.console_app.run(ARGV)
