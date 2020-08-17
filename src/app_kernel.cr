require "glassy-kernel"
require "glassy-console"
require "./bundles/app_bundle/app_bundle"

class AppKernel < Glassy::Kernel::Kernel
  register_bundles [
    Glassy::Console::Bundle,
    AppBundle,
  ]
end
