require "glassy-mongo-odm"
require "../autoload"

module App
  class UserRepository < Glassy::MongoODM::Repository(User)
  end
end
