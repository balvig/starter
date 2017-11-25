require "rpi_gpio"
require "rpi_components"
require "starter/service"

module Starter
  class Main
    def run
      initialize_pins

      while true do
        fetch_and_update
        sleep 300
      end

    rescue Interrupt, Exception => e
      turn_off_all_lights
      reset_pins
      raise
    end

    private

      def initialize_pins
        RpiComponents::setup(numbering: :bcm)
      end

      def lights
        @_lights ||= initialize_lights
      end

      def initialize_lights
        {
          red: RpiComponents::Led.new(17),
          yellow: RpiComponents::Led.new(27),
          green: RpiComponents::Led.new(22)
        }
      end

      def fetch_and_update
        result = Service.new.run
        update_status result[:status]
        logger.info "#{result[:value]} / #{result[:status]}"
      end

      def update_status(status)
        turn_off_all_lights
        light = lights[status]
        light.on if light
      end

      def turn_off_all_lights
        lights.values.map(&:off)
      end

      def reset_pins
        RPi::GPIO.reset
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
