require "glassy-http"
require "../serializer/user_serializer"
require "../repository/user_repository"
require "../service/user_service"

module App
  class UserController < Glassy::HTTP::Controller
    def initialize(@user_serializer : UserSerializer, @user_service : UserService, @user_repository : UserRepository)
    end

    @[Route("POST", "/users")]
    @[JSONBody(arg: "body", required: true)]
    @[JSONBody(arg: "password", path: "data.attributes.password", required: true)]
    def signup(body : JSON::Any, password : JSON::Any)
      user = @user_serializer.deserialize!(body)

      user = @user_service.signup(user, password.as_s)

      @user_serializer.serialize(user)
    end

    @[Route("GET", "/users/current", middlewares: ["auth"])]
    @[Context(arg: "ctx")]
    def current(ctx : HTTP::Server::Context)
      user_id = ctx.get("user_id").to_s
      user = @user_repository.find_by_id!(user_id)
      @user_serializer.serialize(user)
    end
  end
end
