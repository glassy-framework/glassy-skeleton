require "./spec_helper.cr"

describe App::UserController do
  it "create & auth & show user (with success)" do
    post_json "/users", {
      "data" => {
        "type"       => "users",
        "attributes" => {
          "name"     => "My Name",
          "email"    => "my-email@gmail.com",
          "password" => "my_password",
        },
      },
    }.to_json

    response.status_code.should eq 200
    json_response = JSON.parse(response.body)
    json_response["data"]["attributes"]["name"].raw.should eq "My Name"
    json_response["data"]["attributes"]["email"].raw.should eq "my-email@gmail.com"

    post_json "/oauth/token", {
      "grant_type" => "password",
      "username"   => "my-email@gmail.com",
      "password"   => "my_password",
    }.to_json

    response.status_code.should eq 200

    json_response = JSON.parse(response.body)
    access_token = json_response["access_token"].raw

    headers = HTTP::Headers.new
    headers["Authorization"] = "Bearer #{access_token}"

    get "/users/current", headers

    response.status_code.should eq 200
    json_response = JSON.parse(response.body)
    json_response["data"]["attributes"]["name"].raw.should eq "My Name"
    json_response["data"]["attributes"]["email"].raw.should eq "my-email@gmail.com"
  end

  it "invalid create user" do
    post_json "/users", {
      "data" => {
        "type"       => "users",
        "attributes" => {
          "email"    => "my-email@gmail.com",
          "password" => "my_password",
        },
      },
    }.to_json

    response.status_code.should eq 400
    json_response = JSON.parse(response.body)
    json_response["errors"][0]["detail"].should eq "Name can't be empty"

    post_json "/users", {
      "data" => {
        "type"       => "users",
        "attributes" => {
          "name"     => "",
          "email"    => "my-email@gmail.com",
          "password" => "my_password",
        },
      },
    }.to_json

    response.status_code.should eq 400

    json_response = JSON.parse(response.body)
    json_response["errors"][0]["detail"].should eq "Name can't be empty"

    headers = HTTP::Headers.new
    headers["Accept-Language"] = "pt, pt-BR, fr-CH, fr;q=0.9, en;q=0.8, de;q=0.7, *;q=0.5"

    post_json "/users", {
      "data" => {
        "type"       => "users",
        "attributes" => {
          "name"     => "",
          "email"    => "my-email@gmail.com",
          "password" => "my_password",
        },
      },
    }.to_json, headers

    response.status_code.should eq 400

    json_response = JSON.parse(response.body)
    json_response["errors"][0]["detail"].should eq "Nome não pode estar vazio"

    post_json "/users", {
      "data" => {
        "type"       => "users",
        "attributes" => {
          "name"  => "ok",
          "email" => "my-email@gmail.com",
        },
      },
    }.to_json

    response.status_code.should eq 400

    post_json "/users", ""

    response.status_code.should eq 400
  end

  it "invalid auth" do
    post_json "/oauth/token", {
      "password" => "my_password",
    }.to_json

    response.status_code.should eq 400

    post_json "/oauth/token", ""

    response.status_code.should eq 400
  end

  it "invalid users/current" do
    get "/users/current"

    response.status_code.should eq 401
  end
end
