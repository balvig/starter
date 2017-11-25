require "starter/forecast"

module Starter
  class Service
    def run
      {
        status: status,
        value: value,
        title: "Rain: #{value}"
      }
    end

    private

      def value
        rain_probability
      end

      def rain_probability
        @_rain_probability ||= Forecast.new.run
      end

      def status
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
