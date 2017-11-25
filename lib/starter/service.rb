require "starter/forecast"

module Starter
  class Service
    def run
      forecast = Forecast.new
      {
        status: status_for(forecast.rain_probability),
        title: forecast.description,
        body: "Rain: #{forecast.rain_probability * 100}%"
      }
    end

    private

      def status_for(value)
        if value.nil?
          nil
        elsif value >= 0.7
          :red
        elsif value >= 0.4
          :yellow
        else
          :green
        end
      end
  end
end
