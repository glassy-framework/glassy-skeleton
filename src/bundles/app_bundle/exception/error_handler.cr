require "glassy-http"
require "../exception/validation_exception"

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
      else
        super
      end
    end

    def get_status_code(exception : Exception) : Int32
      case exception
      when ValidationException
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
