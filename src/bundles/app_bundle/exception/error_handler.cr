require "glassy-http"
require "glassy-i18n"
require "jsonapi-serializer-cr"
require "./validation_exception"

module App
  class ErrorHandler < Glassy::HTTP::ErrorHandler
    @i18n : Glassy::I18n::Translator?

    def handle_error(ctx : ::HTTP::Server::Context, exception : Exception)
      if ctx.get?("i18n")
        @i18n = ctx.get("i18n").as(Glassy::I18n::Translator)
      end

      super
    end

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
        if exception.error_type == JSONApiSerializer::DeserializeException::ErrorType::REQUIRED_ATTRIBUTE
          attr = exception.path.try(&.split("/").last)
          t("validation.messages.required", {
            "attr" => t("validation.attributes.#{attr}")
          })
        else
          t("errors.malformed_json")
        end
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

    def t(key : String, params : Hash(String, String)? = nil)
      unless @i18n.nil?
        @i18n.not_nil!.t(key, params)
      else
        key
      end
    end
  end
end
