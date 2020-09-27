require "glassy-http"

module App
  class HomeController < Glassy::HTTP::Controller
    @[Route("GET", "/")]
    def index
      "Hello world"
    end
  end
end
