require "./app_kernel"

kernel = AppKernel.new
kernel.container.console_app.run(ARGV)
