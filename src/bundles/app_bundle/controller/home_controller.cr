require "glassy-http"

class HomeController < Glassy::HTTP::Controller
  @[Route("GET", "/")]
  def index
    "Hello world"
  end
end
