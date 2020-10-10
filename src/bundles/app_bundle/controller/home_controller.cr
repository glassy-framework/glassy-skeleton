require "glassy-http"
require "glassy-i18n"

module App
  class HomeController < Glassy::HTTP::Controller
    def initialize(@i18n : Glassy::I18n::Translator)
    end

    @[Route("GET", "/")]
    def index
      @i18n.t("hello_world")
    end
  end
end
