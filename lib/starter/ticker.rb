require "rpi_components"

module Starter
  class Ticker
    CYCLE_INTERVAL = 8
    LCD_RS = 26
    LCD_E = 19
    LCD_D4 = 13
    LCD_D5 = 6
    LCD_D6 = 5
    LCD_D7 = 11

    def initialize
      @lcd = build_lcd
    end

    def cycle(messages = [])
      @thread.exit if @thread
      @thread = Thread.new do
        loop do
          messages.each do |message|
            show message
            sleep CYCLE_INTERVAL
          end
        end
      end
    end

    def clear
      lcd.clear
    end

    private

      attr_reader :lcd

      def show(message)
        lcd.message message[:title]
        lcd.message message[:body], 2
      end

      def build_lcd
        RpiComponents::Lcd.new(
          LCD_RS,
          LCD_E,
          LCD_D4,
          LCD_D5,
          LCD_D6,
          LCD_D7
        )
      end
  end
end
