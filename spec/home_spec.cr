require "./spec_helper"

describe App::HomeController do
  it "GET /" do
    get "/"

    response.status_code.should eq 200
    response.body.should eq "Hello World"

    headers = HTTP::Headers.new
    headers["Accept-Language"] = "pt, pt-BR, fr-CH, fr;q=0.9, en;q=0.8, de;q=0.7, *;q=0.5"

    get "/", headers

    response.status_code.should eq 200
    response.body.should eq "Olá Mundo"
  end
end
