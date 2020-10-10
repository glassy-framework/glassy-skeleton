require "glassy-kernel"
require "glassy-console"
require "glassy-http"
require "glassy-mongo-odm"
require "glassy-i18n"
require "./bundles/app_bundle/bundle"

class AppKernel < Glassy::Kernel::Kernel
  register_bundles [
    Glassy::Console::Bundle,
    Glassy::HTTP::Bundle,
    Glassy::MongoODM::Bundle,
    Glassy::I18n::Bundle,
    App::Bundle,
  ]
end
