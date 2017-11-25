require "logger"
require "rpi_components"
require "starter/api"
require "starter/ticker"

module Starter
  class Main
    UPDATE_INTERVAL = 600
    LED_RED = 17
    LED_YELLOW = 27
    LED_GREEN = 22

    def run
      initialize_pins

      while true do
        fetch_and_update
        sleep UPDATE_INTERVAL
      end

    rescue Interrupt, Exception
      turn_off_all_lights
      ticker.off
      raise
    end

    private

      def initialize_pins
        RpiComponents::setup(numbering: :bcm)
      end

      def lights
        @_lights ||= build_lights
      end

      def build_lights
        {
          red: RpiComponents::Led.new(LED_RED),
          yellow: RpiComponents::Led.new(LED_YELLOW),
          green: RpiComponents::Led.new(LED_GREEN)
        }
      end

      def ticker
        @_ticker ||= Ticker.new
      end

      def fetch_and_update
        result = Api.new.run
        update_status result[:status]
        ticker.cycle result[:messages]
        logger.info result
      end

      def update_status(status)
        turn_off_all_lights
        light = lights[status.to_sym]
        light.on if light
      end

      def turn_off_all_lights
        lights.values.map(&:off)
      end

      def logger
        @_logger ||= build_logger
      end

      def build_logger
        logger = Logger.new(STDOUT)
        logger.formatter = ->(_, datetime, _, msg) { "#{datetime} - #{msg}\n" }
        logger
      end
  end
end
