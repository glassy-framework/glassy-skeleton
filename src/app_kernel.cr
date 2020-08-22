require "glassy-kernel"
require "glassy-console"
require "glassy-http"
require "./bundles/app_bundle/app_bundle"

class AppKernel < Glassy::Kernel::Kernel
  register_bundles [
    Glassy::Console::Bundle,
    Glassy::HTTP::Bundle,
    AppBundle,
  ]
end
