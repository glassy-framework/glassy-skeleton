require "glassy-kernel"
require "glassy-console"
require "glassy-http"
require "glassy-mongo-odm"
require "./bundles/app_bundle/bundle"

class AppKernel < Glassy::Kernel::Kernel
  register_bundles [
    Glassy::Console::Bundle,
    Glassy::HTTP::Bundle,
    Glassy::MongoODM::Bundle,
    App::Bundle,
  ]
end
