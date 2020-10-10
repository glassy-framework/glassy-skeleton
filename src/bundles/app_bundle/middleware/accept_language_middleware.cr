require "http/server"
require "glassy-http"
require "glassy-i18n"

add_context_storage_type(Glassy::I18n::Translator)

module App
  class AcceptLanguageMiddleware < Glassy::HTTP::Middleware
    def initialize(@yaml_data : Glassy::I18n::YAMLData, @i18n_builder : Glassy::Kernel::Builder(Glassy::I18n::Translator))
    end

    def call(ctx : HTTP::Server::Context)
      accept_language = ctx.request.headers["Accept-Language"]?

      unless accept_language.nil?
        languages = accept_language.split(",").map do |lang|
          lang.gsub(" ", "").gsub(/;q.+/, "")
        end

        best_lang = @yaml_data.get_best_language(languages)

        unless best_lang.nil?
          ctx.set "locale", best_lang
        end
      end

      container_ctx = Glassy::Kernel::Context.new
      container_ctx.set("locale", ctx.get?("locale").as(String?))

      ctx.set("i18n", @i18n_builder.make(container_ctx))

      call_next(ctx)
    end
  end
end
