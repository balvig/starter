require "logger"
require "rpi_components"
require "starter/api"
require "starter/ticker"
require "starter/rgb"

module Starter
  class Main
    UPDATE_INTERVAL = 300

    def initialize
      initialize_pins

      #@rgb = Rgb.new
      @ticker = Ticker.new

      sleep 2 # Avoid garbled text
    end

    def run
      while true do
        fetch_and_update
        sleep UPDATE_INTERVAL
      end

    rescue Interrupt, Exception
      #rgb.off
      ticker.clear
      raise
    end

    private

      attr_reader :rgb, :ticker

      def initialize_pins
        RpiComponents::setup(numbering: :bcm)
      end

      def fetch_and_update
        result = Api.new.run
        if result
          #rgb.set_color result[:status]
          ticker.cycle result[:messages]
          logger.info result
        else
          logger.error "Error fetching from API"
        end
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
