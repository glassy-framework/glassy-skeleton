require "glassy-kernel"
require "./autoload"

module App
  class Bundle < Glassy::Kernel::Bundle
    SERVICES_PATH = "#{__DIR__}/config/services.yml"
  end
end
