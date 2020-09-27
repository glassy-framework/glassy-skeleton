require "glassy-mongo-odm"

module App
  include Glassy::MongoODM::Annotations

  @[ODM::Document]
  class User
    @[ODM::Id]
    property id : BSON::ObjectId?

    @[ODM::Field]
    property name : String

    @[ODM::Field]
    property email : String

    @[ODM::Field]
    property password : String?

    @[ODM::Initialize]
    def initialize(@name, @email)
    end
  end
end
