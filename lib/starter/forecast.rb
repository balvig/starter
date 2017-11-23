require "open-weather-api"

module Starter
  class Forecast
    API_KEY = "c205f9ab7b647c699da6c29010cf8829"

    def run
      rain_probability
    end

    private

      def api
        @_api ||= OpenWeatherAPI::API.new api_key: API_KEY
      end

      def result
        api.forecast :hourly, city: "Tokyo", country_code: "jp"
      end

      def rain_probability
        result["list"].first["rain"]["3h"] || 0
      rescue => e
        puts "Forecast error: #{e.message}"
        nil
      end
  end
end
