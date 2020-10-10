require "./serializer"
require "../model/user"

module App
  class UserSerializer < Serializer(User)
    identifier id
    type "users"
    attribute name
    attribute email
  end
end
