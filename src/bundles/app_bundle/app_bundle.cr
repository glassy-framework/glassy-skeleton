require "glassy-kernel"

require "./command/**"

class AppBundle < Glassy::Kernel::Bundle
  SERVICES_PATH = "#{__DIR__}/config/services.yml"
end
