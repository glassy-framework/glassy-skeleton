require "glassy-http"
require "../exception/validation_exception"
require "jsonapi-serializer-cr"

module App
  class ErrorHandler < Glassy::HTTP::ErrorHandler
    def format_exception(exception : Exception)
      {
        "errors" => [
          {
            "status" => get_status_code(exception),
            "detail" => get_error_message(exception),
          },
        ],
      }.to_json
    end

    def get_error_message(exception : Exception) : String
      case exception
      when ValidationException
        exception.message || "Invalid data"
      when JSONApiSerializer::DeserializeException
        exception.message || "Invalid data"
      when JSON::ParseException
        "JSON Parse error: #{exception.message}"
      else
        super
      end
    end

    def get_status_code(exception : Exception) : Int32
      case exception
      when ValidationException
        400
      when JSONApiSerializer::DeserializeException
        400
      when JSON::ParseException
        400
      else
        super
      end
    end

    def get_content_type(exception : Exception) : String
      "application/json"
    end
  end
end
