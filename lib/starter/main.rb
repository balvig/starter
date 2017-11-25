require "rpi_gpio"
require "rpi_components"
require "starter/service"

module Starter
  class Main
    LED_RED = 17
    LED_YELLOW = 27
    LED_GREEN = 22
    LCD_RS  = 26
    LCD_E   = 19
    LCD_D4  = 13
    LCD_D5  = 6
    LCD_D6  = 5
    LCD_D7  = 11

    def run
      initialize_pins

      while true do
        fetch_and_update
        sleep 300
      end

    rescue Interrupt, Exception => e
      turn_off_all_lights
      lcd.off
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
          red: RpiComponents::Led.new(LED_RED),
          yellow: RpiComponents::Led.new(LED_YELLOW),
          green: RpiComponents::Led.new(LED_GREEN)
        }
      end

      def lcd
        @_lcd ||= RpiComponents::Lcd.new(LCD_RS, LCD_E, LCD_D4, LCD_D5, LCD_D6, LCD_D7)
      end

      def fetch_and_update
        result = Service.new.run
        update_status result[:status]
        lcd.message result[:title]
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
