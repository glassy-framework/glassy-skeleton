require "glassy-mongo-odm"
require "../model/user"

module App
  class UserRepository < Glassy::MongoODM::Repository(User)
  end
end
