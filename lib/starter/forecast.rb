require "open-weather-api"

module Starter
  class Forecast
    API_KEY = "c205f9ab7b647c699da6c29010cf8829"

    def rain_probability
      data.fetch("rain", {})["3h"] || 0
    end

    def description
      data["weather"].first["description"]
    end

    private

      def data
        @_data ||= fetch["list"].first
      end

      def fetch
        api.forecast :hourly, city: "Tokyo", country_code: "jp"
      end

      def api
        @_api ||= OpenWeatherAPI::API.new api_key: API_KEY
      end
  end
end
