require "jsonapi-serializer-cr"

module App
  abstract class Serializer(T) < JSONApiSerializer::ResourceSerializer(T)
  end
end
