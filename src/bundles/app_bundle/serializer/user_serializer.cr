require "jsonapi-serializer-cr"
require "../autoload"

module App
  class UserSerializer < JSONApiSerializer::ResourceSerializer(User)
    identifier id
    type "users"
    attribute name
    attribute email
  end
end
